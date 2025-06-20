----------------------------------------------
------------MOD CODE -------------------------

SMODS.Atlas {
	key = "jokers",
	path = "atlas_joker.png",
	px = 71,
	py = 95
}

SMODS.Atlas {
	key = "timmy",
	path = "timmy.png",
	px = 71,
	py = 95
}

SMODS.Atlas {
	key = "peter",
	path = "peter.png",
	px = 71,
	py = 95
}

SMODS.Atlas {
	key = "placeholders",
	path = "atlas_placeholder.png",
	px = 71,
	py = 95
}

SMODS.Sound {
	key = "pop",
	path = "pop.ogg",
	loop = false,
	volume = 0.5,
}

SMODS.Sound {
	key = "eat",
	path = "eat.ogg",
	loop = false,
	volume = 0.5,
}

SMODS.Joker {
	key = "bulgoe",
	config = { extra = { chips = 2.7 } },
	rarity = 1,
	atlas =  "crp_jokers",
	blueprint_compat = true,
	demicolon_compat = true,
	pos = { x = 0, y = 0 },
	cost = 1,
	loc_vars = function(self, info_queue, card)
		return { vars = { lenient_bignum(card.ability.extra.chips) } }
	end,
	calculate = function(self, card, context)
		if (context.joker_main) or context.forcetrigger then
			return {
				chips = lenient_bignum(card.ability.extra.chips)
			}
		end
	end,
	crp_credits = {
		idea = { "Poker The Poker" },
		art = { "Poker The Poker" },
		code = { "Glitchkat10" },
		custom = { key = "everything",text = "Bulgoe" }
	}
}

SMODS.Joker {
	key = "normalis", -- hd bulgoe :fire:
	config = { extra = { Echips = 2.7, Emult = 2.7 } },
	rarity = "cry_exotic",
	atlas =  "crp_jokers",
	blueprint_compat = true,
	demicolon_compat = true,
	pos = { x = 1, y = 0 },
	soul_pos = { x = 2, y = 0, extra = { x = 3, y = 0 } },
	cost = 50,
	loc_vars = function(self, info_queue, card)
		return { vars = { lenient_bignum(card.ability.extra.Echips), } }
	end,
	calculate = function(self, card, context)
		if (context.joker_main) or context.forcetrigger then
			return {
				Echip_mod = lenient_bignum(card.ability.extra.Echips),
				Emult_mod = lenient_bignum(card.ability.extra.Emult),
				message = localize({
					type = "variable",
					key = "a_powmultchips",
					vars = { number_format(lenient_bignum(card.ability.extra.Echips)) },
				}),
				colour = { 0.8, 0.45, 0.85, 1 }, -- plasma deck colors
			}
		end
	end,
	crp_credits = {
		idea = { "Poker The Poker" },
		art = { "Tatteredlurker" },
		code = { "Glitchkat10" }
	}
}

SMODS.Joker {
	key = "sprinter",
	config = { extra = { chips = 0, chips_scale = 75 } },
	rarity = 1,
	atlas = "crp_jokers",
	pos = { x = 4, y = 0 },
	cost = 5,
	blueprint_compat = true,
	demicolon_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { lenient_bignum(card.ability.extra.chips), lenient_bignum(card.ability.extra.chips_scale) } }
	end,
	calculate = function(self, card, context)
		if (context.joker_main) or context.forcetrigger then
			return {
				chips = lenient_bignum(card.ability.extra.chips),
			}
		end
		if (context.before and next(context.poker_hands["Straight Flush"]) and not context.blueprint) or context.forcetrigger then
			card.ability.extra.chips = lenient_bignum(card.ability.extra.chips) + lenient_bignum(card.ability.extra.chips_scale)
			return {
				message = "Upgraded!",
				colour = G.C.CHIPS,
				card = card
			}
		end
	end,
	crp_credits = {
		idea = { "Poker The Poker" },
		art = { "MarioFan597" },
		code = { "Glitchkat10" }
	}
}

-- man.............. - rainstar
--[[ SMODS.Joker {
	key = "scones_bones",
	config = { extra = { death_prevention_enabled = true, score_percentage = 50, xchips = 3, xchips_mod = 0.01, stones = 2 } },
	rarity = 3,
	atlas = "crp_placeholders",
	pos = { x = 4, y = 0 },
	cost = 8,
	blueprint_compat = true,
	demicolon_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.death_prevention_enabled, card.ability.extra.score_percentage, card.ability.extra.xchips, card.ability.extra.xchips_mod, card.ability.extra.stones } }
	end,
	calculate = function(self, card, context)
		-- ill be honest i just stole like most of the things here from cryptid lmao
		if context.game_over and to_big(G.GAME.chips / G.GAME.blind.chips) <= to_big(card.ability.extra.score_percentage / 100) and card.ability.extra.death_prevention_enabled == true then
			G.E_MANAGER:add_event(Event({
				func = function()
					G.hand_text_area.blind_chips:juice_up()
					G.hand_text_area.game_chips:juice_up()
					play_sound("tarot1")
					return true
				end,
			}))
		card.ability.extra.death_prevention_enabled = false
		return {
			message = localize("k_saved_ex"),
			saved = true,
			colour = G.C.RED,
		}
		end
		if context.selling_self then
			card.ability.extra.death_prevention_enabled = false
		end
		if (context.joker_main) or context.forcetrigger then
			return {
				card = card,
				Xchip_mod = lenient_bignum(card.ability.extra.xchips),
				message = "X" .. number_format(card.ability.extra.xchips),
				colour = G.C.CHIPS,
			}
		end
		-- this is completely stolen from marble joker's code
		if context.before and next(context.poker_hands["Flush"]) or context.forcetrigger then
			local stone_cards = lenient_bignum(card.ability.extra.stones)
			for i = 1, stone_cards do
                G.E_MANAGER:add_event(Event({
                    func = function() 
                        local front = pseudorandom_element(G.P_CARDS, pseudoseed("marb_fr"))
                        G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                        local card = Card(G.play.T.x + G.play.T.w/2, G.play.T.y, G.CARD_W, G.CARD_H, front, G.P_CENTERS.m_stone, {playing_card = G.playing_card})
                        card:start_materialize({G.C.SECONDARY_SET.Enhanced})
                        G.hand:emplace(card)
                        table.insert(G.playing_cards, card)
                        return true
                    end})
				)
                card_eval_status_text(context.blueprint_card or self, "extra", nil, nil, nil, {message = localize("k_plus_stone"), colour = G.C.SECONDARY_SET.Enhanced})
                G.E_MANAGER:add_event(Event({
                    func = function() 
                        G.deck.config.card_limit = G.deck.config.card_limit + 1
                        return true
                    end})
				)
                draw_card(G.play,G.deck, 90,"up", nil)
                playing_card_joker_effects({true})
			end
		end
		if context.cry_press then
			if to_big(card.ability.extra.xchips) <= to_big(1) then
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound("tarot1")
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({
							trigger = "after",
							delay = 0.3,
							blockable = false,
							func = function()
								G.jokers:remove_card(card)
								card:remove()
								card = nil
								return true
							end,
						}))
						return true
					end,
				}))
				card_eval_status_text(
					card,
					"extra",
					nil,
					nil,
					nil,
					{ message = localize("k_eaten_ex"), colour = G.C.CHIPS }
				)
			else
				card.ability.extra.xchips =
					lenient_bignum(to_big(card.ability.extra.xchips) - card.ability.extra.xchips_mod)
				card_eval_status_text(
					card,
					"extra",
					nil,
					nil,
					nil,
					{ message = "-X" .. number_format(card.ability.extra.xchips_mod) .. "Chips", colour = G.C.CHIPS }
				)
			end
		end
	end,
	crp_credits = {
		idea = { "Poker The Poker" },
		code = { "Rainstar" }
	}
} ]]--

SMODS.Joker {
	key = "jogger",
	config = { extra = { chips = 0, chips_scale = 5 } },
	rarity = 1,
	atlas = "crp_jokers",
	pos = { x = 5, y = 0 },
	cost = 5,
	blueprint_compat = true,
	demicolon_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { lenient_bignum(card.ability.extra.chips), lenient_bignum(card.ability.extra.chips_scale) } }
	end,
	calculate = function(self, card, context)
		if (context.joker_main) or context.forcetrigger then
			return {
				chips = lenient_bignum(card.ability.extra.chips),
			}
		end
		if (context.before and next(context.poker_hands["High Card"]) and not context.blueprint) or context.forcetrigger then
			card.ability.extra.chips = lenient_bignum(card.ability.extra.chips) + lenient_bignum(card.ability.extra.chips_scale)
			return {
				message = "Upgraded!",
				colour = G.C.CHIPS,
				card = card
			}
		end
	end,
	crp_credits = {
		idea = { "Poker The Poker" },
		art = { "MarioFan597" },
		code = { "Glitchkat10" }
	}
}

SMODS.Joker {
    key = "tetration_timmy",
    config = { extra = { EEmult = 1.1 } },
    rarity = "cry_exotic",
    atlas = "timmy",
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 7, extra = { x = 0, y = 7 } },
    cost = 50,
    blueprint_compat = true,
    demicolon_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { lenient_bignum(card.ability.extra.EEmult) } }
    end,
    calculate = function(self, card, context)
        if (context.joker_main) or context.forcetrigger then
            return {
                message = "^^" .. lenient_bignum(card.ability.extra.EEmult) .. " Mult",
                EEmult_mod = lenient_bignum(card.ability.extra.EEmult),
                colour = G.C.DARK_EDITION,
                card = card
            }
        end
    end,
    animation = {
        macro = {
        type = "skim",
        pos = {
            include = {{x1=0,x2=3,y1=0,y2=6}},
            exclude = {{x1=0,x2=3,y1=7,y2=7}},
        },
        }
    },
    crp_credits = {
        idea = { "Poker The Poker","Glitchkat10" },
        art = { "MarioFan597" },
        code = { "Glitchkat10" }
    }
}

SMODS.Joker {
	key = "perdurantes",
	config = { extra = { Emult = 1, Emult_mod = 1, retrigger_requirement = 50, current_retriggers = 0 } },
	rarity = "cry_exotic",
	atlas = "crp_placeholders",
	pos = { x = 7, y = 0 },
	cost = 50,
	blueprint_compat = true,
	demicolon_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { lenient_bignum(card.ability.extra.Emult), lenient_bignum(card.ability.extra.Emult_mod), lenient_bignum(card.ability.extra.retrigger_requirement), lenient_bignum(card.ability.extra.current_retriggers) } }
	end,
	calculate = function(self, card, context)
		if (context.joker_main) or context.forcetrigger then
			if card.ability.extra.current_retriggers >= card.ability.extra.retrigger_requirement - 1 then
				card.ability.extra.current_retriggers = 0
				card.ability.extra.Emult = card.ability.extra.Emult + card.ability.extra.Emult_mod
				return {
					message = "^" .. lenient_bignum(card.ability.extra.Emult) .. " Mult",
					Emult_mod = lenient_bignum(card.ability.extra.Emult),
					colour = G.C.DARK_EDITION,
					card = card
				}
			else
				card.ability.extra.current_retriggers = card.ability.extra.current_retriggers + 1
				return {
					message = "^" .. lenient_bignum(card.ability.extra.Emult) .. " Mult",
					Emult_mod = lenient_bignum(card.ability.extra.Emult),
					colour = G.C.DARK_EDITION,
					card = card
				}
			end
		end
	end,
	crp_credits = {
		idea = { "Poker The Poker" },
		code = { "Rainstar" }
	}
}

-- commented out due to the current effect being graveyarded
--[[ SMODS.Joker {
	key = "dead_joker",
	config = { immutable = { mult = 107 } },
	rarity = 2,
	atlas = "crp_jokers",
	pos = { x = 6, y = 0 },
	cost = 7,
	blueprint_compat = true,
	demicolon_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.immutable.mult } }
	end,
	calculate = function(self, card, context)
		if (context.joker_main) or context.forcetrigger then
			return {
				mult = card.ability.immutable.mult
			}
		end
	end,
	crp_credits = {
		idea = { "Poker The Poker" },
		art = { "GudUsername" },
		code = { "Glitchkat10" }
	}
} ]]--

SMODS.Joker {
	key = "joker_of_all_trades",
	config = { extra = { chips = 150, mult = 15, dollars = 3 } },
	rarity = 2,
	atlas = "crp_jokers",
	pos = { x = 3, y = 1 },
	cost = 7,
	blueprint_compat = true,
	demicolon_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { lenient_bignum(card.ability.extra.chips), lenient_bignum(card.ability.extra.mult), lenient_bignum(card.ability.extra.dollars) } }
	end,
	calculate = function(self, card, context)
		if (context.joker_main) or context.forcetrigger then
			return {
				chips = lenient_bignum(card.ability.extra.chips),
				mult = lenient_bignum(card.ability.extra.mult)
			}
		end
		if context.forcetrigger then
			ease_dollars(lenient_bignum(card.ability.extra.dollars))
			return { message = "$" .. lenient_bignum(card.ability.extra.dollars), colour = G.C.MONEY }
		end
	end,
	calc_dollar_bonus = function(self, card)
		return lenient_bignum(card.ability.extra.dollars)
	end,
	crp_credits = {
		idea = { "Poker The Poker" },
		art = { "GudUsername" },
		code = { "Glitchkat10" }
	}
}

SMODS.Joker {
	key = "millipede",
	config = { extra = { chips = 1000, full_hand = 1 } },
	rarity = 3,
	atlas = "crp_jokers",
	pos = { x = 6, y = 2 },
	cost = 10,
	blueprint_compat = true,
	demicolon_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { lenient_bignum(card.ability.extra.chips), lenient_bignum(card.ability.extra.full_hand) } }
	end,
	calculate = function(self, card, context)
		if (context.joker_main and context.full_hand and #context.full_hand == lenient_bignum(card.ability.extra.full_hand)) or context.forcetrigger then
			return {
				chips = lenient_bignum(card.ability.extra.chips)
			}
		end
	end,
	crp_credits = {
		idea = { "Poker The Poker" },
		art = { "Tatteredlurker" },
		code = { "Glitchkat10" }
	}
}

SMODS.Joker {
	key = "joker_2",
	config = { extra = { chips = 4 } },
	rarity = 1,
	atlas = "crp_jokers",
	pos = { x = 7, y = 0 },
	cost = 1,
	blueprint_compat = true,
	demicolon_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { lenient_bignum(card.ability.extra.chips) } }
	end,
	calculate = function(self, card, context)
		if (context.joker_main) or context.forcetrigger then
			return {
				chips = lenient_bignum(card.ability.extra.chips)
			}
		end
	end,
	crp_credits = {
		idea = { "borb43" },
		art = { "Glitchkat10" },
		code = { "Glitchkat10" }
	}
}

SMODS.Joker {
	key = "joker_3",
	config = { extra = { Xmult = 4 } },
	rarity = 3,
	atlas = "crp_jokers",
	pos = { x = 8, y = 0 },
	cost = 8,
	blueprint_compat = true,
	demicolon_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { lenient_bignum(card.ability.extra.Xmult) } }
	end,
	calculate = function(self, card, context)
		if (context.joker_main) or context.forcetrigger then
			return {
				Xmult = lenient_bignum(card.ability.extra.Xmult)
			}
		end
	end,
	crp_credits = {
		idea = { "Poker The Poker" },
		art = { "Glitchkat10" },
		code = { "Glitchkat10" }
	}
}

SMODS.Joker {
	key = "joker_4",
	config = { extra = { Emult = 4 } },
	rarity = "cry_exotic",
	atlas = "crp_jokers",
	pos = { x = 0, y = 1 },
	soul_pos = { x = 1, y = 1, extra = { x = 2, y = 1 } },
	cost = 50,
	blueprint_compat = true,
	demicolon_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { lenient_bignum(card.ability.extra.Emult) } }
	end,
	calculate = function(self, card, context)
		if (context.joker_main) or context.forcetrigger then
			return {
				message = localize({
					type = "variable",
					key = "a_powmult",
					vars = {
						number_format(lenient_bignum(card.ability.extra.Emult)),
					},
				}),
				Emult_mod = lenient_bignum(card.ability.extra.Emult),
				colour = G.C.DARK_EDITION,
			}
		end
	end,
	crp_credits = {
		idea = { "borb43" },
		art = { "Glitchkat10" },
		code = { "Glitchkat10" }
	}
}

SMODS.Joker {
	key = "joker_5",
	config = { extra = { EEmult = 4 } },
	rarity = "crp_mythic",
	atlas = "crp_jokers",
	pos = { x = 1, y = 2 },
	soul_pos = { x = 2, y = 2, extra = { x = 3, y = 2 } },
	cost = (4^4)/(math.sqrt(4)),
	blueprint_compat = true,
	demicolon_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { lenient_bignum(card.ability.extra.EEmult) } }
	end,
	calculate = function(self, card, context)
		if (context.joker_main) or context.forcetrigger then
			return {
				message = "^^" .. lenient_bignum(card.ability.extra.EEmult) .. " Mult",
				EEmult_mod = lenient_bignum(card.ability.extra.EEmult),
				colour = G.C.DARK_EDITION,
				card = card
			}
		end
	end,
	crp_credits = {
		idea = { "Poker The Poker" },
		art = { "Glitchkat10" },
		code = { "Glitchkat10" }
	}
}

SMODS.Joker {
	key = "joker_6",
	config = { extra = { dollars = 4 } },
	rarity = 2,
	atlas = "crp_jokers",
	pos = { x = 6, y = 1 },
	cost = 9,
	blueprint_compat = true,
	demicolon_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { lenient_bignum(card.ability.extra.dollars) } }
	end,
	calculate = function(self, card, context)
		if (context.joker_main) or context.forcetrigger then
			ease_dollars(lenient_bignum(card.ability.extra.dollars))
			return { message = "$" .. number_format(lenient_bignum(card.ability.extra.dollars)), colour = G.C.MONEY }
		end
	end,
	crp_credits = {
		idea = { "borb43" },
		art = { "Glitchkat10" },
		code = { "Glitchkat10" }
	}
}

SMODS.Joker {
	key = "joker_7",
	config = { extra = { create = 4 } },
	rarity = "cry_epic",
	atlas = "crp_jokers",
	pos = { x = 7, y = 1 },
	cost = 16,
	blueprint_compat = true,
	demicolon_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { lenient_bignum(card.ability.extra.create) } }
	end,
	calculate = function(self, card, context)
		local tarots_to_create = lenient_bignum(card.ability.extra.create)
      		G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + tarots_to_create
		for i = 1, tarots_to_create do
			if (context.joker_main) or context.forcetrigger then
        		local card_type = "Tarot"
        		G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
        		G.E_MANAGER:add_event(Event({
          			trigger = "before",
         			delay = 0.0,
          			func = (function()
              			local n_card = create_card(card_type,G.consumeables, nil, nil, nil, nil, nil, "jk7")
              			n_card:add_to_deck()
              			G.consumeables:emplace(n_card)
              			G.GAME.consumeable_buffer = 0
           			return true
          			end)}))
			end
		end
	end,
	crp_credits = {
		idea = { "Unknown" },
		art = { "Glitchkat10" },
		code = { "Glitchkat10" }
	}
}

SMODS.Joker {
	key = "joker_8",
	config = { extra = { Xchips = 4 } },
	rarity = 3,
	atlas = "crp_jokers",
	pos = { x = 0, y = 3 },
	cost = 10,
	blueprint_compat = true,
	demicolon_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { lenient_bignum(card.ability.extra.Xchips) } }
	end,
	calculate = function(self, card, context)
		if (context.joker_main) or context.forcetrigger then
			return {
				message = localize({
					type = "variable",
					key = "a_xchips",
					vars = { number_format(card.ability.extra.Xchips) },
				}),
				Xchip_mod = lenient_bignum(card.ability.extra.Xchips),
				colour = G.C.CHIPS,
			}
		end
	end,
	crp_credits = {
		idea = { "Poker The Poker" },
		art = { "Glitchkat10" },
		code = { "Glitchkat10" }
	}
}

SMODS.Joker {
	key = "joker?",
	config = { extra = { mult = 4 } },
	rarity = 1,
	atlas = "crp_jokers",
	pos = { x = 5, y = 4 },
	cost = 4.4,
	blueprint_compat = true,
	demicolon_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { lenient_bignum(card.ability.extra.mult) } }
	end,
	calculate = function(self, card, context)
		if (context.joker_main) or context.forcetrigger then
			if
				next(SMODS.find_card("j_joker"))
				and next(SMODS.find_card("j_crp_joker_2"))
				and next(SMODS.find_card("j_crp_joker_3"))
				and next(SMODS.find_card("j_crp_joker_4"))
				and next(SMODS.find_card("j_crp_joker_5"))
				and next(SMODS.find_card("j_crp_joker_6"))
				and next(SMODS.find_card("j_crp_joker_7"))
				and next(SMODS.find_card("j_crp_joker_8"))
				and next(SMODS.find_card("j_crp_joker_0")) 
			then
				return {
					hypermult_mod = {
						4,
						lenient_bignum(card.ability.extra.mult)
					},
					message = "{4}" .. lenient_bignum(card.ability.extra.mult) .. " Mult",
					colour = G.C.EDITION,
				}
			else
				return {
					mult = lenient_bignum(card.ability.extra.mult)
				}
			end
		end
	end,
	crp_credits = {
		idea = { "Unknown", "Glitchkat10" },
		art = { "Glitchkat10" },
		code = { "Glitchkat10" }
	}
}

SMODS.Joker {
	key = "jolly_of_joker",
	config = { extra = { Emult = 8 } },
	rarity = "cry_exotic",
	atlas = "crp_jokers",
	pos = { x = 1, y = 5 },
	soul_pos = { x = 3, y = 5, extra = { x = 2, y = 5 } },
	cost = 50,
	blueprint_compat = true,
	demicolon_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { lenient_bignum(card.ability.extra.Emult) } }
	end,
	calculate = function(self, card, context)
		if (context.joker_main and next(context.poker_hands["Pair"])) or context.forcetrigger then
			return {
				message = localize({
					type = "variable",
					key = "a_powmult",
					vars = {
						number_format(lenient_bignum(card.ability.extra.Emult)),
					},
				}),
				Emult_mod = lenient_bignum(card.ability.extra.Emult),
				colour = G.C.DARK_EDITION,
			}
		end
	end,
	crp_credits = {
		idea = { "Unknown" },
		art = { "Tatteredlurker" },
		code = { "Rainstar" }
	}
}

SMODS.Joker {
	key = "evil_jolly_joker",
	config = { extra = { mult = 8 } },
	rarity = "cry_cursed",
	atlas = "crp_jokers",
	pos = { x = 9, y = 1 },
	cost = 0,
	blueprint_compat = true,
	demicolon_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { lenient_bignum(card.ability.extra.mult) } }
	end,
	calculate = function(self, card, context)
		if (context.joker_main and not next(context.poker_hands["Pair"])) or context.forcetrigger then
			return {
				message = "÷" .. lenient_bignum(card.ability.extra.mult) .. " Mult",
				Xmult_mod = 1 / lenient_bignum(card.ability.extra.mult),
				colour = G.C.MULT,
			}
		end
	end,
	crp_credits = {
		idea = { "Unknown", "Glitchkat10" },
		code = { "Rainstar" }
	}
}

SMODS.Joker {
	key = "duplicare_2",
	config = { extra = { Xmult = 1, Xmult_gain = 0.25, retriggers = 1 } },
	rarity = "crp_exotic_2",
	atlas = "crp_jokers",
	pos = { x = 7, y = 5 },
	soul_pos = { x = 9, y = 5, extra = { x = 8, y = 5 } },
	cost = 50,
	blueprint_compat = true,
	demicolon_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { lenient_bignum(card.ability.extra.Xmult), lenient_bignum(card.ability.extra.Xmult_gain), lenient_bignum(card.ability.extra.retriggers) } }
	end,
	calculate = function(self, card, context) 
		if context.retrigger_joker_check and not context.retrigger_joker and context.other_card ~= card then
			return {
				message = localize("k_again_ex"),
				repetitions = lenient_bignum(card.ability.extra.retriggers),
				card = card,
			}
		end
		if context.repetition and context.cardarea == G.play then
			return {
				message = localize("k_again_ex"),
				repetitions = lenient_bignum(card.ability.extra.retriggers),
				card = card,
			}
		end
		if context.post_trigger and context.other_joker ~= card then
			card.ability.extra.Xmult = lenient_bignum(card.ability.extra.Xmult) + lenient_bignum(card.ability.extra.Xmult_gain)
			card_eval_status_text(card, "extra", nil, nil, nil, { message = localize("k_upgrade_ex") })
		end
		if context.individual and context.cardarea == G.play then
			card.ability.extra.Xmult = lenient_bignum(card.ability.extra.Xmult) + lenient_bignum(card.ability.extra.Xmult_gain)
			card_eval_status_text(card, "extra", nil, nil, nil, { message = localize("k_upgrade_ex") })
		end
		if (context.joker_main) or context.forcetrigger then
			return {
				Xmult = lenient_bignum(card.ability.extra.Xmult),
			}
		end
	end,
	crp_credits = {
		idea = { "Glitchkat10" },
		art = { "Tatteredlurker" },
		code = { "Rainstar" }
	}
}

SMODS.Joker {
	key = "evil_joker",
	config = { extra = { mult = 4 } },
	rarity = "cry_cursed",
	atlas = "crp_jokers",
	pos = { x = 8, y = 1 },
	cost = 0,
	blueprint_compat = true,
	demicolon_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { lenient_bignum(card.ability.extra.mult) } }
	end,
	calculate = function(self, card, context)
		if (context.joker_main) or context.forcetrigger then
			return {
				message = "÷" .. lenient_bignum(card.ability.extra.mult) .. " Mult",
				Xmult_mod = 1 / lenient_bignum(card.ability.extra.mult),
				colour = G.C.MULT,
			}
		end
	end,
	crp_credits = {
		idea = { "Glitchkat10" },
		art = { "Glitchkat10" },
		code = { "Glitchkat10" }
	}
}

SMODS.Joker {
	key = "progressive",
	config = {
		extra = {
			mult = 1,
			Xmult = 1,
		}
	},
	rarity = "cry_epic",
	atlas = "crp_placeholders",
	pos = { x = 5, y = 0 },
	cost = 15,
	blueprint_compat = true,
	demicolon_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { lenient_bignum(card.ability.extra.mult), lenient_bignum(card.ability.extra.Xmult) } }
	end,
	calculate = function(self, card, context)
		if context.setting_blind then
			card.ability.extra.mult = lenient_bignum(G.GAME.round)
			card.ability.extra.Xmult = lenient_bignum(G.GAME.round_resets.ante)
		end
		if (context.joker_main) or context.forcetrigger then
			return {
				mult_mod = lenient_bignum(card.ability.extra.mult),
				Xmult_mod = lenient_bignum(card.ability.extra.Xmult),
				message = "Progressum!",
				colour = G.C.MULT,
				card = card
			}
		end
	end,
	crp_credits = {
		idea = { "Poker The Poker", "Glitchkat10" },
		code = { "Rainstar" }
	}
}

SMODS.Joker {
	key = "infinitum",
	config = {
		extra = {
			chipsmult = 2
		}
	},
	rarity = "crp_2exomythic4me",
	atlas = "crp_placeholders",
	pos = { x = 11, y = 0 },
	cost = 400,
	blueprint_compat = true,
	demicolon_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { lenient_bignum(card.ability.extra.chipsmult), "{", "}" } }
	end,
	calculate = function(self, card, context)
		-- jokers, doesnt work as of now

	    --if context.other_card ~= self and context.cardarea == G.jokers then
		--	local arrow_number_jokers = 0
		--	for i = 1, #G.jokers.cards do
		--		if context.other_card == G.jokers.cards[i] then
		--			arrow_number_jokers = i
		--		end
		--	end
		--	if context.post_trigger and context.other_card == G.jokers.cards[arrow_number_jokers] then
		--		if arrow_number_jokers == 1 then
		--			return {
		--				message = localize({
		--					type = "variable",
		--					key = "a_powmultchips",
		--					vars = { number_format(lenient_bignum(card.ability.extra.chipsmult)) },
		--				}),
		--				Echip_mod = card.ability.extra.chipsmult,
		--				Emult_mod = card.ability.extra.chipsmult
		--			}
		--		elseif arrow_number_jokers == 2 then
		--			return {
		--				message = "^^" .. lenient_bignum(card.ability.extra.chipsmult) .. " Chips & Mult",
		--				colour = G.C.EDITION,
		--				EEchip_mod = card.ability.extra.chipsmult,
		--				EEmult_mod = card.ability.extra.chipsmult
		--			}
		--		elseif arrow_number_jokers == 3 then
		--			return {
		--				message = "^^^" .. lenient_bignum(card.ability.extra.chipsmult) .. " Chips & Mult",
		--				colour = G.C.EDITION,
		--				EEEchip_mod = card.ability.extra.chipsmult,
		--				EEEmult_mod = card.ability.extra.chipsmult
		--			}
		--		elseif arrow_number_jokers >= 4 then
		--			return {
		--				message = "{" .. arrow_number_jokers .. "} " .. lenient_bignum(card.ability.extra.chipsmult) .. " Chips & Mult",
		--				colour = G.C.EDITION,
		--				hyperchip_mod = {arrow_number_jokers, card.ability.extra.chipsmult},
		--				hypermult_mod = {arrow_number_jokers, card.ability.extra.chipsmult}
		--			}
		--		end
		--	end
		--end

		-- playing cards
		local arrow_number_cards = 0
		if context.individual and context.cardarea == G.play then
			local arrow_number_cards = 1
			for k, v in ipairs(G.play.cards) do
				if v == context.other_card then
					arrow_number_cards = k
					break
				end
			end
			if lenient_bignum(arrow_number_cards) == 1 then
				return {
					message = "^" .. lenient_bignum(card.ability.extra.chipsmult) .. " Chips & Mult",
					colour = G.C.DARK_EDITION,
					Echip_mod = lenient_bignum(card.ability.extra.chipsmult),
					Emult_mod = lenient_bignum(card.ability.extra.chipsmult)
				}
			elseif lenient_bignum(arrow_number_cards) == 2 then
				return {
					message = "^^" .. lenient_bignum(card.ability.extra.chipsmult) .. " Chips & Mult",
					colour = G.C.DARK_EDITION,
					EEchip_mod = lenient_bignum(card.ability.extra.chipsmult),
					EEmult_mod = lenient_bignum(card.ability.extra.chipsmult)
				}
			elseif lenient_bignum(arrow_number_cards) == 3 then
				return {
					message = "^^^" .. lenient_bignum(card.ability.extra.chipsmult) .. " Chips & Mult",
					colour = G.C.EDITION,
					EEEchip_mod = lenient_bignum(card.ability.extra.chipsmult),
					EEEmult_mod = lenient_bignum(card.ability.extra.chipsmult)
				}
			elseif lenient_bignum(arrow_number_cards) >= 4 then
				return {
					message = "{" .. lenient_bignum(arrow_number_cards) .. "} " .. lenient_bignum(card.ability.extra.chipsmult) .. " Chips & Mult",
					colour = G.C.EDITION,
					hyperchip_mod = {lenient_bignum(arrow_number_cards), lenient_bignum(card.ability.extra.chipsmult)},
					hypermult_mod = {lenient_bignum(arrow_number_cards), lenient_bignum(card.ability.extra.chipsmult)}
				}
			end
		end
	end,
	crp_credits = {
		idea = { "Unknown" },
		code = { "Rainstar" }
	}
}

SMODS.Joker {
	key = "joker_0",
	config = { extra = { create = 4 } },
	rarity = 3,
	atlas = "crp_jokers",
	pos = { x = 8, y = 4 },
	cost = 9,
	blueprint_compat = true,
	demicolon_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { lenient_bignum(card.ability.extra.create) } }
	end,
	calculate = function(self, card, context)
		local jokers_to_create = lenient_bignum(card.ability.extra.create)
      	G.GAME.joker_buffer = G.GAME.joker_buffer + jokers_to_create
		for i = 1, jokers_to_create do
			if (context.joker_main) or context.forcetrigger then
				local card = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_joker")
				card:add_to_deck()
				card:start_materialize()
				G.jokers:emplace(card)
			end
		end
	end,
	crp_credits = {
		idea = { "lord.ruby" },
		art = { "Glitchkat10" },
		code = { "Glitchkat10" }
	}
}

SMODS.Joker {
    key = "jonkler",
    config = { immutable = { arrows = 25000, EEEmult = 1 } },
    rarity = "crp_trash",
    atlas = "crp_placeholders",
    pos = { x = 1, y = 0 },
    cost = 0,
    blueprint_compat = true,
	demicolon_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { "{", "}", } }
    end,
    calculate = function(self, card, context)
        if (context.joker_main) or context.force_trigger then
            return {
				EEEmult_mod = card.ability.immutable.EEEmult,
                message = "{" .. card.ability.immutable.arrows .. "}" .. card.ability.immutable.EEEmult .. " Mult",
                colour = G.C.EDITION,
                card = card
            }
		end
    end,
	in_pool = function(self, args)
		return true, { allow_duplicates = true }
	end,
    crp_credits = {
        idea = { "Unknown", "Glitchkat10" },
        code = { "Glitchkat10" }
    }
}

SMODS.Joker {
	key = "quetta_m",
	config = { extra = { operator = -1, mult = 8, operator_increase = 8 }, immutable = { numerator = 13, denominator = 100 } },
	rarity = "crp_22exomythic4mecipe",
	atlas = "crp_placeholders",
	pos = { x = 10, y = 0 },
	cost = 800,
	blueprint_compat = true,
	demicolon_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { lenient_bignum(card.ability.extra.operator), lenient_bignum(card.ability.extra.mult), lenient_bignum(card.ability.extra.operator_increase), "{", "}" } }
	end,
	calculate = function(self, card, context)
		if (context.joker_main) or context.forcetrigger then
			if card.ability.extra.operator <= -1 then
				return {
					mult_mod = lenient_bignum(card.ability.extra.mult),
					message = "+" .. lenient_bignum(card.ability.extra.mult) .. " Mult",
					colour = G.C.MULT
				}
			elseif card.ability.extra.operator == 0 then
				return {
					Xmult_mod = lenient_bignum(card.ability.extra.mult),
					message = "X" .. lenient_bignum(card.ability.extra.mult) .. " Mult",
					colour = G.C.MULT
				}
			elseif card.ability.extra.operator == 1 then
				return {
					Emult_mod = lenient_bignum(card.ability.extra.mult),
					message = "^" .. lenient_bignum(card.ability.extra.mult) .. " Mult",
					colour = G.C.DARK_EDITION
				}
			elseif card.ability.extra.operator == 2 then
				return {
					EEmult_mod = lenient_bignum(card.ability.extra.mult),
					message = "^^" .. lenient_bignum(card.ability.extra.mult) .. " Mult",
					colour = G.C.DARK_EDITION
				}
			elseif card.ability.extra.operator == 3 then
				return {
					EEEmult_mod = lenient_bignum(card.ability.extra.mult),
					message = "^^^" .. lenient_bignum(card.ability.extra.mult) .. " Mult",
					colour = G.C.EDITION
				}
			else  -- guys the elseif chain isn't THAT massive syfm 🥀
				return {
					hypermult_mod = {
						lenient_bignum(card.ability.extra.operator),
						lenient_bignum(card.ability.extra.mult)
					},
					message = "{" .. lenient_bignum(card.ability.extra.operator) .. "}" .. lenient_bignum(card.ability.extra.mult) .. " Mult",
					colour = G.C.EDITION
				}
			end
		end

		local roll = pseudorandom("quetta_m")
		local chance = lenient_bignum(card.ability.immutable.numerator) / lenient_bignum(card.ability.immutable.denominator)
		if (context.before and context.scoring_name == "Pair" and not context.blueprint) or context.forcetrigger then
			if roll <= chance then
				card.ability.extra.operator = card.ability.extra.operator + card.ability.extra.operator_increase
				return {
					message = "Upgraded!",
					card = card
				}
			end
		end
	end,
	crp_credits = {
		idea = { "superb_thing", "Glitchkat10" },
		code = { "Rainstar", "Glitchkat10" }
	}
}

SMODS.Joker {
	key = "pi_joker",
	config = { extra = {  } },
	rarity = 3,
	atlas = "crp_jokers",
	pos = { x = 1, y = 3 },
	cost = 10,
	blueprint_compat = true,
	demicolon_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = {  } }
	end,
	calculate = function(self, card, context)
		if (context.joker_main) or context.forcetrigger then
			return {
				message = localize({
					type = "variable",
					key = "a_xchips",
					vars = { math.pi },
				}),
				Xchip_mod = math.pi,
				colour = G.C.CHIPS,
				extra = {
					Xmult = math.pi
				}
			}
		end
	end,
	crp_credits = {
		idea = { "Unknown" },
		art = { "Glitchkat10" },
		code = { "Glitchkat10" }
	}
}
SMODS.Joker {
	key = "weather_machine",
	config = { extra = { mult_mod = 1e76, death_prevention_enabled = true, mult = 0 } },
	rarity = "crp_mythic",
	atlas = "crp_placeholders",
	pos = { x = 8, y = 0 },
	cost = 100,
	blueprint_compat = true,
	demicolon_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { lenient_bignum(card.ability.extra.mult_mod), card.ability.extra.death_prevention_enabled, lenient_bignum(card.ability.extra.mult) } }
	end,
	calculate = function(self, card, context)
		if context.game_over and lenient_bignum(G.GAME.chips / G.GAME.blind.chips) < lenient_bignum(1) and card.ability.extra.death_prevention_enabled == true then
			G.E_MANAGER:add_event(Event({
				func = function()
					G.hand_text_area.blind_chips:juice_up()
					G.hand_text_area.game_chips:juice_up()
					play_sound("tarot1")
					return true
				end,
			}))
		card.ability.extra.death_prevention_enabled = false
		card.ability.extra.mult = lenient_bignum(card.ability.extra.mult) + lenient_bignum(card.ability.extra.mult_mod)
		return {
			message = "Saved & Upgraded!",
			saved = true,
			colour = G.C.RED,
		}
		end
		if context.selling_self then
			card.ability.extra.death_prevention_enabled = false
		end
		if context.joker_main and card.ability.extra.death_prevention_enabled == false or context.forcetrigger then
			return {
				card = card,
				mult_mod = lenient_bignum(card.ability.extra.mult),
				message = "+" .. number_format(lenient_bignum(card.ability.extra.mult)) .. "Mult",
				colour = G.C.MULT,
			}
		end
	end,
	crp_credits = {
		idea = { "Poker The Poker" },
		code = { "Rainstar" }
	}
}

SMODS.Joker {
	key = "semicolon",
	config = { extra = {  } },
	rarity = "crp_trash",
	atlas = "crp_jokers",
	pos = { x = 0, y = 5 },
	cost = 0,
	blueprint_compat = true,
	demicolon_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = {  } }
	end,
	calculate = function(self, card, context)
		if (context.joker_main) or context.forcetrigger then
			local ind = nil
			for i, v in pairs(G.jokers.cards) do
				if v == card then ind = i+1 end
			end
			if ind and G.jokers.cards[ind] then
				card_eval_status_text(card, "extra", nil, nil, nil, { message = "plz", colour = { 0.8, 0.45, 0.85, 1 }, delay = 5 } )
				return {
					message = "Nope!",
					delay = 1,
					colour = G.C.PURPLE,
					card = G.jokers.cards[ind]
				}
			end
		end
		return nil
	end,
	in_pool = function(self, args)
		return true, { allow_duplicates = true }
	end,
	crp_credits = {
		idea = { "lord.ruby", "Glitchkat10" },
		art = { "Tatteredlurker" },
		code = { "Glitchkat10", "lord.ruby" }
	}
}

SMODS.Joker {
	key = ":3",
	rarity = "crp_:3",
	atlas = "crp_jokers",
	pos = { x = 6, y = 3 },
	cost = 0,
	blueprint_compat = false,
	demicolon_compat = false,
	in_pool = function(self, args)
		return true, { allow_duplicates = true }
	end,
	crp_credits = {
		idea = { "lord.ruby" },
		art = { "Glitchkat10" },
		code = { "Glitchkat10" },
		custom = { key = "colon_3", text = "why are you here; this joker literally does nothing" }
	}
}

SMODS.Joker {
	key = "sigma-man",
	pos = { x = 7, y = 4 },
	pools = { ["Meme"] = true },
	rarity = "crp_cipe",
	cost = 15,
	perishable_compat = true,
	atlas = "crp_jokers",
	calculate = function(self, card, context)
		local chance = 1 / 4
		local roll = pseudorandom("sigma-man")
		if
			context.selling_card
			and context.card.ability.name == "cry-Chad"
			and not context.retrigger_joker
			and not context.blueprint
		then
			return {}
		elseif
			(
				(
				context.selling_self
				or context.discard
				or context.before
				or context.reroll_shop
				or context.buying_card
				or context.skip_blind
				or context.using_consumeable
				or context.selling_card
				or context.setting_blind
				or context.skipping_booster
				or context.open_booster
				or context.forcetrigger
				)
				and roll <= chance
			)
			and #G.jokers.cards + G.GAME.joker_buffer < (context.selling_self and (G.jokers.config.card_limit + 1) or G.jokers.config.card_limit)
			and not context.retrigger_joker
			and not context.blueprint
		then
			local createjoker = math.min(1, G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer))
				G.GAME.joker_buffer = G.GAME.joker_buffer + createjoker
			local card = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_cry_chad")
			card:add_to_deck()
			G.jokers:emplace(card)
			G.GAME.joker_buffer = 0
		end
	end,
	add_to_deck = function(self, card, from_debuff)
		if not from_debuff then
			local card = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_cry_chad")
			card:set_edition("e_negative", true, nil, true)
			card.ability.cry_absolute = true
			card:add_to_deck()
			G.jokers:emplace(card)
		end
	end,
	crp_credits = {
		idea = { "Unknown" },
		art = { "Lexi" },
		code = { "Lexi" }
	},
}

SMODS.Joker {
	key = "apple",
	config = { extra = { mult = 1, rounds_remaining = 10 } },
	rarity = 1,
	atlas =  "crp_jokers",
	pos = { x = 3, y = 4 },
	cost = 1,
	blueprint_compat = true,
	demicolon_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { lenient_bignum(card.ability.extra.mult), lenient_bignum(card.ability.extra.rounds_remaining) } }
	end,
	calculate = function(self, card, context)
		if (context.joker_main) or context.forcetrigger then
			return {
				mult = lenient_bignum(card.ability.extra.mult)
			}
		end
		if
			(context.end_of_round
			and not context.blueprint
			and not context.individual
			and not context.repetition
			and not context.retrigger_joker)
			or context.forcetrigger
		then
			card.ability.extra.rounds_remaining = lenient_bignum(lenient_bignum(card.ability.extra.rounds_remaining) - 1)
			if
				lenient_bignum(card.ability.extra.rounds_remaining) <= 0
			then
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound("crp_eat")
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({
							trigger = "after",
							delay = 0.3,
							blockable = false,
							func = function()
								G.jokers:remove_card(card)
								card:remove()
								card = nil
								return true
							end,
						}))
						return true
					end,
				}))
				return {
					message = localize("k_eaten"),
					colour = G.C.FILTER,
				}
			end
		end
	end,
	crp_credits = {
		idea = { "Unknown" },
		art = { "Lexi" },
		code = { "Lexi" }
	}
}

SMODS.Joker {
	key = "exodiac",
	config = { extra = { EEEmult = 1.13 } },
	rarity = "crp_2exomythic4me",
	atlas = "crp_placeholders",
	pos = { x = 11, y = 0 },
	-- soul_pos = { x = 0, y = 0, extra = { x = 0, y = 0 } },
	cost = 400,
	blueprint_compat = true,
	demicolon_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { lenient_bignum(card.ability.extra.EEEmult) } }
	end,
	calculate = function(self, card, context)
		if context.ending_shop then
			local card = create_card("Joker", G.jokers, nil, "cry_exotic", nil, nil, nil, "exotic_generator_moment") -- this is true
			card:set_edition({ negative = true }, true)
			card:add_to_deck()
			G.jokers:emplace(card)
		end
		if context.other_joker and context.other_joker.config.center.rarity == "cry_exotic" then
			return {
				EEEmult_mod = lenient_bignum(card.ability.extra.EEEmult),
				message = "^^^" .. lenient_bignum(card.ability.extra.EEEmult) .. " Mult",
				colour = G.C.EDITION,
			}
		end
	end,
	crp_credits = {
		idea = { "Poker The Poker" },
		code = { "Rainstar" }
	}
}

SMODS.Joker {
	key = "heptation_henry",
	config = { immutable = { arrows = 7 }, extra = { hypermult = 1.1 } },
	rarity = "crp_exomythic",
	atlas = "crp_placeholders",
	pos = { x = 9, y = 0 },
	-- soul_pos = { x = 0, y = 0, extra = { x = 0, y = 0 } },
	cost = 200,
	blueprint_compat = true,
	demicolon_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { lenient_bignum(card.ability.extra.hypermult) } }
	end,
	calculate = function(self, card, context)
		if (context.joker_main) or context.forcetrigger then
			return {
				hypermult_mod = {
					lenient_bignum(card.ability.immutable.arrows),
					lenient_bignum(card.ability.extra.hypermult)
				},
				message = "^^^^^" .. lenient_bignum(card.ability.extra.hypermult) .. " Mult",
				colour = G.C.EDITION,
			}
		end
	end,
	crp_credits = {
		idea = { "Glitchkat10" },
		code = { "Glitchkat10" }
	}
}

SMODS.Joker {
	key = "morble",
	config = { extra = { Emoney = 2 } },
	rarity = "crp_exomythic",
	atlas = "crp_placeholders",
	pos = { x = 9, y = 0 },
	-- soul_pos = { x = 0, y = 0, extra = { x = 0, y = 0 } },
	cost = 200,
	blueprint_compat = true,
	demicolon_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { lenient_bignum(card.ability.extra.Emoney) } }
	end,
	calculate = function(self, card, context)
		if context.other_joker then
			G.GAME.dollars = G.GAME.dollars ^ lenient_bignum(card.ability.extra.Emoney)
			return {
				message = "^$" .. lenient_bignum(card.ability.extra.Emoney),
				colour = G.C.MONEY,
			}
		end
	end,
	crp_credits = {
		idea = { "Poker The Poker" },
		code = { "Rainstar" }
	}
}

SMODS.Joker {
	key = "room_for_all",
	config = { extra = { slots = 1e100 } },
	rarity = "crp_mythic",
	atlas = "crp_placeholders",
	pos = { x = 8, y = 0 },
	cost = 100,
	blueprint_compat = false,
	demicolon_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { lenient_bignum(card.ability.extra.slots) } }
	end,
	add_to_deck = function(self, card, from_debuff)
		G.hand:change_size(card.ability.extra.slots)
		G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.slots
		G.consumeables.config.card_limit = G.consumeables.config.card_limit + card.ability.extra.slots
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.hand:change_size(-card.ability.extra.slots)
		G.hand:change_size(8)
		G.jokers.config.card_limit = 5
		G.consumeables.config.card_limit = 2
	end,
	crp_credits = {
		idea = { "Poker The Poker" },
		code = { "Rainstar" }
	}
}
SMODS.Joker {
	key = "exponentia_2",
	config = { extra = { Emult = 1, Emult_mod = 0.3 } },
	rarity = "crp_exotic_2",
	atlas = "crp_placeholders",
	pos = { x = 7, y = 0 },
	cost = 100,
	blueprint_compat = true,
	demicolon_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { lenient_bignum(card.ability.extra.Emult), lenient_bignum(card.ability.extra.Emult_mod) } }
	end,
	calculate = function(self, card, context)
		if (context.joker_main) or context.forcetrigger then
			return {
				message = "^" .. lenient_bignum(card.ability.extra.Emult) .. " Mult",
				Emult_mod = lenient_bignum(card.ability.extra.Emult),
				colour = G.C.DARK_EDITION,
				card = card
			}
		end
	end,
	-- still stolen from cryptids exponentia
	init = function(self)
		-- Hook for scaling
		local scie = SMODS.calculate_individual_effect
		function SMODS.calculate_individual_effect(effect, scored_card, key, amount, from_edition)
			local ret = scie(effect, scored_card, key, amount, from_edition)
			if
				(
					key == "e_mult"
					or key == "emult"
					or key == "Emult"
					or key == "e_mult_mod"
					or key == "emult_mod"
					or key == "Emult_mod"
				)
				and amount ~= 1
				and mult
			then
				for _, v in pairs(find_joker("j_crp_exponentia_2")) do
					local old = v.ability.extra.Emult
					v.ability.extra.Emult = lenient_bignum(to_big(v.ability.extra.Emult) + v.ability.extra.Emult_mod)
					card_eval_status_text(v, "extra", nil, nil, nil, {
						message = localize({
							type = "variable",
							key = "a_tetmult",
							vars = { number_format(v.ability.extra.Emult) },
						}),
					})
					Cryptid.apply_scale_mod(v, v.ability.extra.Emult_mod, old, v.ability.extra.Emult, {
						base = { { "extra", "Emult" } },
						scaler = { { "extra", "Emult_mod" } },
						scaler_base = { v.ability.extra.Emult_mod },
					})
				end
			end
			return ret
		end
	end,
	crp_credits = {
		idea = { "Poker The Poker" },
		code = { "Rainstar" }
	}
}

SMODS.Joker {
	key = "bulgoes_hiking_journey",
	config = { extra = { perma_x_chips = 0.27 } },
	rarity = "cry_epic",
	atlas =  "crp_jokers",
	blueprint_compat = true,
	demicolon_compat = false,
	pos = { x = 0, y = 7 },
	cost = 13,
	loc_vars = function(self, info_queue, card)
		return { vars = { lenient_bignum(card.ability.extra.perma_x_chips) } }
	end,
	calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            context.other_card.ability.perma_x_chips = lenient_bignum(context.other_card.ability.perma_x_chips) or 0
            context.other_card.ability.perma_x_chips = lenient_bignum(context.other_card.ability.perma_x_chips) + lenient_bignum(card.ability.extra.perma_x_chips)
            return {
                extra = { message = localize("k_upgrade_ex"), colour = G.C.CHIPS },
                card = card
			}
		end
	end,
	crp_credits = {
		idea = { "Poker The Poker" },
		art = { "Glitchkat10" },
		code = { "Poker The Poker" },
	}
}

SMODS.Joker {
	key = "water_bottle",
	config =
		{ extra = { splash = 5 } },
		{ immutable = { max_spawn = 100 } }, -- idk how to fix it lol
	rarity = 2,
	atlas = "crp_jokers",
	pos = { x = 1, y = 4 },
	cost = 6,
	eternal_compat = false,
	blueprint_compat = true,
	demicolon_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { lenient_bignum(card.ability.extra.splash) } }
	end,
	calculate = function(self, card, context)
		if (context.selling_self) or context.forcetrigger then
			for i = 1, math.floor(lenient_bignum(card.ability.extra.splash)) do
				local card = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_splash")
				card:add_to_deck()
				G.jokers:emplace(card)
			end
		end
	end,
	crp_credits = {
		idea = { "Glitchkat10" },
		art = { "Tatteredlurker" },
		code = { "Lexi" }
	}
}

SMODS.Joker {
	key = "playerrkillerr",
	config = { immutable = { mult = 284 } },
	rarity = 3,
	atlas = "crp_jokers",
	pos = { x = 4, y = 1 },
	cost = 9,
	blueprint_compat = true,
	demicolon_compat = true,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.c_black_hole
		info_queue[#info_queue + 1] = G.P_CENTERS.p_arcana_normal_1
		info_queue[#info_queue + 1] = G.P_CENTERS.p_celestial_normal_1
		info_queue[#info_queue + 1] = G.P_CENTERS.p_spectral_normal_1
		return { vars = { "{", "}" } }
	end,
	calculate = function(self, card, context)
		if (context.joker_main) or context.forcetrigger then
			return {
				mult = card.ability.immutable.mult
			}
		end
	end,
	crp_credits = {
		idea = { "Glitchkat10" },
		art = { "MarioFan597" },
		code = { "Glitchkat10" }
	}
}

SMODS.Joker {
    key = "purist_jolly_joker",
    config = { extra = { mult = 16 } },
    rarity = 1,
    atlas = "crp_jokers",
    pos = { x = 5, y = 3 },
    cost = 4,
    blueprint_compat = true,
	demicolon_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { lenient_bignum(card.ability.extra.mult) } }
    end,
    calculate = function(self, card, context)
        if (context.joker_main and context.scoring_name == "Pair") or context.forcetrigger then
            return {
                mult = lenient_bignum(card.ability.extra.mult)
            }
        end
    end,
    crp_credits = {
        idea = { "Poker The Poker" },
        art = { "Glitchkat10" },
        code = { "Glitchkat10" }
    }
}

SMODS.Joker {
	key = "big_joker",
	config = { extra = { mult = 15 } },
	rarity = 1,
	atlas = "crp_placeholders",
	pos = { x = 2, y = 0 },
	display_size = { w = 2 * 71, h = 2 * 95 },
	cost = 6,
	blueprint_compat = true,
	demicolon_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { lenient_bignum(card.ability.extra.mult) } }
	end,
	calculate = function(self, card, context)
		if (context.joker_main) or context.forcetrigger then
			return {
				mult = lenient_bignum(card.ability.extra.mult)
			}
		end
	end,
	crp_credits = {
		idea = { "Unknown" },
		code = { "Glitchkat10" }
	}
}

SMODS.Joker {
	key = "bulgoe_prize",
	config = { extra = { create = 1 } },
	rarity = 1,
	atlas =  "crp_jokers",
	pos = { x = 4, y = 4 },
	cost = 3,
	blueprint_compat = true,
	demicoloncompat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { lenient_bignum(card.ability.extra.create) } }
	end,
	calculate = function(self, card, context)
		if (context.skipping_booster) or context.forcetrigger then
		    local jokers_to_create = lenient_bignum(card.ability.extra.create)
      	    G.GAME.joker_buffer = G.GAME.joker_buffer + jokers_to_create
		    for i = 1, jokers_to_create do
				local card = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_crp_bulgoe")
				card:add_to_deck()
				card:start_materialize()
				G.jokers:emplace(card) 
				card:juice_up(0.3, 0.4)
			end
			return {
				message = localize("k_bulgoe_spawn"),
				colour = G.C.BLUE,
			}
		end
	end,
	crp_credits = {
		idea = { "Unknown" },
		art = { "Lexi" },
		code = { "Lexi", "Glitchkat10" }
	}
}

SMODS.Joker {
	key = "chip",
	config = { immutable = { chips = 1 } },
	rarity = 1,
	atlas = "crp_jokers",
	pos = { x = 0, y = 4 },
	cost = 1,
	blueprint_compat = true,
	demicolon_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = {  } }
	end,
	calculate = function(self, card, context)
		if (context.joker_main) or context.forcetrigger then
			return {
				chips = lenient_bignum(card.ability.immutable.chips)
			}
		end
	end,
	crp_credits = {
		idea = { "UTnerd24" },
		art = { "Lexi", "Glitchkat10" },
		code = { "Lexi" }
	}
}

SMODS.Joker {
	key = "gamblecore",
	config = { immutable = { numerator = 1, denominator = 255, mult = 179769313486231570814527423731704356798070567525844996598917476803157260780028538760589558632766878171540458953514382464234321326889464182768467546703537516986049910576551282076245490090389328944075868508455133942304583236903222948165808559332123348274797826204144723168738177180919299881250404026184124858368 } },
	rarity = 2,
	atlas = "crp_jokers",
	pos = { x = 9, y = 0 },
	cost = 5,
	blueprint_compat = true,
	demicolon_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.immutable.numerator, card.ability.immutable.denominator, card.ability.immutable.mult } }
	end,
	calculate = function(self, card, context)
		if (context.joker_main) or context.forcetrigger then
			local roll = pseudorandom("gamblecore")
			local chance = lenient_bignum(card.ability.immutable.numerator) / lenient_bignum(card.ability.immutable.denominator)

			if roll <= chance or context.forcetrigger then
				return {
					message = "+nane0 Mult",
					mult_mod = 179769313486231570814527423731704356798070567525844996598917476803157260780028538760589558632766878171540458953514382464234321326889464182768467546703537516986049910576551282076245490090389328944075868508455133942304583236903222948165808559332123348274797826204144723168738177180919299881250404026184124858368,
					colour = G.C.MULT,
					card = card
				}
			end
		end
	end,
	crp_credits = {
		idea = { "Unknown" },
		art = { "GudUsername", "Glitchkat10" },
		code = { "Glitchkat10" }
	}
}

SMODS.Joker {
	key = "centipede",
	config = { extra = { chips = 100, full_hand = 1 } },
	rarity = 2,
	atlas = "crp_jokers",
	pos = { x = 5, y = 2 },
	cost = 6,
	blueprint_compat = true,
	demicolon_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { lenient_bignum(card.ability.extra.chips), lenient_bignum(card.ability.extra.full_hand) } }
	end,
	calculate = function(self, card, context)
		if (context.joker_main and context.full_hand and #context.full_hand == lenient_bignum(card.ability.extra.full_hand)) or context.forcetrigger then
			return {
				chips = lenient_bignum(card.ability.extra.chips)
			}
		end
	end,
	crp_credits = {
		idea = { "Poker The Poker" },
		art = { "Tatteredlurker" },
		code = { "Glitchkat10" }
	}
}

SMODS.Joker {
	key = "dorito",
	config = { immutable = { mult = 1 } },
	rarity = 1,
	atlas = "crp_jokers",
	pos = { x = 4, y = 6 },
	cost = 1,
	blueprint_compat = true,
	demicolon_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = {  } }
	end,
	calculate = function(self, card, context)
		if (context.joker_main) or context.forcetrigger then
			return {
				mult = lenient_bignum(card.ability.immutable.mult)
			}
		end
	end,
	crp_credits = {
		idea = { "brionic9673914" },
		art = { "Glitchkat10" },
		code = { "Glitchkat10", "Lexi" }
	}
}

SMODS.Joker {
	key = "decipede",
	config = { extra = { chips = 10, full_hand = 1 } },
	rarity = 1,
	atlas = "crp_jokers",
	pos = { x = 4, y = 2 },
	cost = 1,
	blueprint_compat = true,
	demicolon_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { lenient_bignum(card.ability.extra.chips), lenient_bignum(card.ability.extra.full_hand) } }
	end,
	calculate = function(self, card, context)
		if (context.joker_main and context.full_hand and #context.full_hand == lenient_bignum(card.ability.extra.full_hand)) or context.forcetrigger then
			return {
				chips = lenient_bignum(card.ability.extra.chips)
			}
		end
	end,
	crp_credits = {
		idea = { "Glitchkat10" },
		art = { "Tatteredlurker" },
		code = { "Glitchkat10" }
	}
}

SMODS.Joker {
	key = "pentation_peter",
	config = { extra = { EEEmult = 1.1 } },
	rarity = "crp_mythic",
	atlas = "peter",
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 7, extra = { x = 0, y = 7 } },
	cost = 100,
	blueprint_compat = true,
	demicolon_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { lenient_bignum(card.ability.extra.EEEmult) } }
	end,
	calculate = function(self, card, context)
		if (context.joker_main) or context.forcetrigger then
			return {
				message = "^^^" .. lenient_bignum(card.ability.extra.EEEmult) .. " Mult",
				EEEmult_mod = lenient_bignum(card.ability.extra.EEEmult),
				colour = G.C.EDITION,
				card = card
			}
		end
	end,
	animation = {
        macro = {
        type = "skim",
        pos = {
            include = {{x1=0,x2=3,y1=0,y2=6}},
            exclude = {{x1=0,x2=3,y1=7,y2=7}},
        },
        }
    },
	crp_credits = {
		idea = { "Glitchkat10" },
		art = { "MarioFan597" },
		code = { "Glitchkat10" }
	}
}

SMODS.Joker {
	key = "tetrationa",
	config = { extra = { EEmult = 1, EEmult_mod = 0.3 } },
	rarity = "crp_mythic",
	atlas = "crp_placeholders",
	pos = { x = 8, y = 0 },
	cost = 100,
	blueprint_compat = true,
	demicolon_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { lenient_bignum(card.ability.extra.EEmult), lenient_bignum(card.ability.extra.EEmult_mod) } }
	end,
	calculate = function(self, card, context)
		if (context.joker_main) or context.forcetrigger then
			return {
				message = "^^" .. lenient_bignum(card.ability.extra.EEmult) .. " Mult",
				EEmult_mod = lenient_bignum(card.ability.extra.EEmult),
				colour = G.C.DARK_EDITION,
				card = card
			}
		end
	end,
	-- stole this from cryptids exponentia
	init = function(self)
		-- Hook for scaling
		local scie = SMODS.calculate_individual_effect
		function SMODS.calculate_individual_effect(effect, scored_card, key, amount, from_edition)
			local ret = scie(effect, scored_card, key, amount, from_edition)
			if
				(
					key == "e_mult"
					or key == "emult"
					or key == "Emult"
					or key == "e_mult_mod"
					or key == "emult_mod"
					or key == "Emult_mod"
				)
				and amount ~= 1
				and mult
			then
				for _, v in pairs(find_joker("j_crp_tetrationa")) do
					local old = v.ability.extra.EEmult
					v.ability.extra.EEmult = lenient_bignum(to_big(v.ability.extra.EEmult) + v.ability.extra.EEmult_mod)
					card_eval_status_text(v, "extra", nil, nil, nil, {
						message = localize({
							type = "variable",
							key = "a_tetmult",
							vars = { number_format(v.ability.extra.EEmult) },
						}),
					})
					Cryptid.apply_scale_mod(v, v.ability.extra.EEmult_mod, old, v.ability.extra.EEmult, {
						base = { { "extra", "EEmult" } },
						scaler = { { "extra", "EEmult_mod" } },
						scaler_base = { v.ability.extra.EEmult_mod },
					})
				end
			end
			return ret
		end
	end,
	crp_credits = {
		idea = { "Poker The Poker" },
		code = { "Rainstar" }
	}
}

SMODS.Joker {
    key = "bulgoeship_card",
    config = { extra = { EEmult_mod = 0.1 } },
    rarity = "crp_mythic",
    atlas = "crp_jokers",
    pos = { x = 1, y = 7 },
    soul_pos = { x = 2, y = 7, extra = { x = 3, y = 7 } },
    cost = 100,
    blueprint_compat = true,
    demicolon_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { number_format(card.ability.extra.EEmult_mod), number_format(card.ability.extra.EEmult_mod) * Cryptposting.member_count, }, }
    end,
    calculate = function(self, card, context)
    print("look for this")
    Cryptposting.update_member_count()
        if (context.joker_main and lenient_bignum(lenient_bignum(card.ability.extra.EEmult_mod) * lenient_bignum(Cryptposting.member_count)) > lenient_bignum(1)) or context.forcetrigger then
            return {
                message = "^^" .. number_format(lenient_bignum(lenient_bignum(card.ability.extra.EEmult_mod) * lenient_bignum(Cryptposting.member_count))) .. " Mult",
                EEmult_mod = lenient_bignum(lenient_bignum(card.ability.extra.EEmult_mod) * lenient_bignum(Cryptposting.member_count)),
                colour = G.C.DARK_EDITION,
                card = card
            }
        end
    end,
    crp_credits = {
        idea = { "Poker The Poker" },
        art = { "Glitchkat10", "HexaCryonic" },
        code = { "Glitchkat10", "Tesseffex" }
    }
}

SMODS.Joker {
	key = "iterum_2",
	config = { extra = { Xmult = 1.05, retriggers = 10 }, immutable = { max_retriggers = 400 }, },
	rarity = "crp_exotic_2",
	atlas = "crp_jokers",
	pos = { x = 4, y = 5 },
	soul_pos = { x = 5, y = 5, extra = { x = 6, y = 5 } },
	cost = 50,
	blueprint_compat = true,
	demicolon_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { lenient_bignum(card.ability.extra.Xmult), math.min(lenient_bignum(card.ability.immutable.max_retriggers), lenient_bignum(card.ability.extra.retriggers)), lenient_bignum(card.ability.immutable.max_retriggers) } }
	end,
	calculate = function(self, card, context)
		if context.repetition then
			if context.cardarea == G.play then
				return {
					message = localize("k_again_ex"),
					repetitions = to_number(math.min(lenient_bignum(card.ability.immutable.max_retriggers), lenient_bignum(card.ability.extra.retriggers))),
					card = card,
				}
			end
		elseif context.individual then
			if context.cardarea == G.play then
				return {
					message = "X" .. number_format(lenient_bignum(card.ability.extra.Xmult)) .. " Mult",
					Xmult_mod = lenient_bignum(card.ability.extra.Xmult),
					colour = G.C.MULT,
				}
			end
		end
		if context.forcetrigger then
			return {
				message = "X" .. number_format(lenient_bignum(card.ability.extra.Xmult)) .. " Mult",
				Xmult_mod = lenient_bignum(card.ability.extra.Xmult),
				colour = G.C.MULT,
			}
		end
	end,
	crp_credits = {
		idea = { "Glitchkat10", "MarioFan597" },
		art = { "Tatteredlurker" },
		code = { "Glitchkat10", "MathIsFun_" }
	}
}

SMODS.Joker {
	key = "underflow",
	config = { extra = { Xmult = 1, Xmult_scale = 1 } },
	rarity = "crp_mythic",
	atlas = "crp_placeholders",
	pos = { x = 8, y = 0 },
	-- soul_pos = { x = 0, y = 0, extra = { x = 0, y = 0 } },
	cost = 100,
	blueprint_compat = true,
	demicolon_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { lenient_bignum(card.ability.extra.Xmult), lenient_bignum(card.ability.extra.Xmult_scale) } }
	end,
	calculate = function(self, card, context)
		if ((context.joker_main) or context.forcetrigger) and card.ability.extra.Xmult ~= 0 then
			return {
				Xmult = lenient_bignum(card.ability.extra.Xmult),
			}
		end
		if (context.end_of_round and not context.blueprint and not context.individual and not context.repetition and not context.retrigger_joker) or context.forcetrigger then
			if card.ability.extra.Xmult > -1 then
				card.ability.extra.Xmult = lenient_bignum(card.ability.extra.Xmult) - lenient_bignum(card.ability.extra.Xmult_scale)
			end
			if card.ability.extra.Xmult <= -1 then
				card.ability.extra.Xmult = 179769313486231570814527423731704356798070567525844996598917476803157260780028538760589558632766878171540458953514382464234321326889464182768467546703537516986049910576551282076245490090389328944075868508455133942304583236903222948165808559332123348274797826204144723168738177180919299881250404026184124858368
			end -- the number above is the max value of a double in lua, which is ~1.7976931348623157e308. this number is usually referred to as "naneinf" in balatro. attempting to use the operation (2^1024) - 1 momentarily results in a number too big for lua to process, so i have to use this long-winded integer instead.
		end
	end,
	crp_credits = {
		idea = { "MarioFan597", "Glitchkat10" },
		code = { "Glitchkat10" }
	}
}

SMODS.Joker {
	key = "statically_charged",
	config = { extra = {  } },
	rarity = "crp_exomythic",
	atlas = "crp_jokers",
	pos = { x = 1, y = 6 },
	soul_pos = { x = 2, y = 6, extra = { x = 3, y = 6 } },
	cost = 200,
	blueprint_compat = true,
	demicolon_compat = false,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.e_crp_overloaded
		return { vars = {  } }
	end,
	add_to_deck = function(self, card, from_debuff)
		if G.GAME.modifiers.cry_force_edition and not G.GAME.modifiers.cry_force_edition_from_deck then
			G.GAME.modifiers.cry_force_edition_from_deck = G.GAME.modifiers.cry_force_edition
		elseif not G.GAME.modifiers.cry_force_edition_from_deck then
			G.GAME.modifiers.cry_force_edition = "crp_overloaded"
		end
	end,
	remove_from_deck = function(self, card, from_debuff)
		if G.GAME.modifiers.cry_force_edition_from_deck ~= "Nope!" then
			G.GAME.modifiers.cry_force_edition = G.GAME.modifiers.cry_force_edition_from_deck
		else
			G.GAME.modifiers.cry_force_edition = nil
		end
	end,
	crp_credits = {
		idea = { "Glitchkat10" },
		art = { "Tatteredlurker" },
		code = { "Glitchkat10", "MathIsFun_" }
	}
}

SMODS.Joker {
	key = "bullshit",
	config = { extra = { amount = 1 } },
	rarity = 1,
	atlas = "crp_placeholders",
	pos = { x = 2, y = 0 },
	cost = 5,
	blueprint_compat = false,
	demicolon_compat = true,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.j_bull
		return { vars = { lenient_bignum(card.ability.extra.amount) } }
	end,
	calculate = function(self, card, context)
		if (context.selling_self) or context.forcetrigger then
			for i = 1, lenient_bignum(card.ability.extra.amount) do -- usually amount will be 1, making this joker mutable isn't needed but it's very funny
				-- flip coin essentially to decide which to make
				local tableofcreation = {}
				local pickedside = pseudorandom_element({ 1, 2 }, pseudoseed("advancedchessbattle"))
				if pickedside == 1 then -- bull
					tableofcreation = {
						set = "Joker",
						key = "j_bull"
					}
				else -- trash
					tableofcreation = {
						set = "Joker",
						rarity = "crp_trash"
					}
				end
				SMODS.add_card(tableofcreation) -- make the card (SMODS.add_card my beloved)
			end
		end
	end,
	crp_credits = {
		idea = { "Poker The Poker" },
		code = { "ScarredOut" }
	}
}

SMODS.Joker {
	key = "playerrwon",
	config = { extra = { arrows = 1, mult = 9, arrows_scale = 1 }, immutable = { max = 500 } },
	rarity = "crp_22exomythic4mecipe",
	atlas = "crp_placeholders",
	pos = { x = 10, y = 0 },
	-- soul_pos = { x = 0, y = 0, extra = { x = 0, y = 0 } },
	cost = 800,
	blueprint_compat = true,
	demicolon_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { lenient_bignum(math.min(lenient_bignum(card.ability.extra.arrows), lenient_bignum(card.ability.immutable.max))), lenient_bignum(card.ability.extra.mult), lenient_bignum(card.ability.extra.arrows_scale), "{", "}" } }
	end,
	calculate = function(self, card, context)
		if (context.joker_main) or context.forcetrigger then
			return {
				hypermult_mod = {
					lenient_bignum(math.round(lenient_bignum(math.min(lenient_bignum(card.ability.extra.arrows), lenient_bignum(card.ability.immutable.max))))), -- do you like parentheses
					lenient_bignum(card.ability.extra.mult)
				},
				message = "{" .. lenient_bignum(math.min(lenient_bignum(card.ability.extra.arrows), lenient_bignum(card.ability.immutable.max))) .. "}" .. lenient_bignum(card.ability.extra.mult) .. " Mult",
				colour = G.C.EDITION,
			}
		end
		if (context.end_of_round and not context.blueprint and not context.retrigger and not context.individual and not context.repetition) or context.forcetrigger then
			card.ability.extra.arrows = lenient_bignum(card.ability.extra.arrows) + lenient_bignum(card.ability.extra.arrows_scale)
		end
	end,
	crp_credits = {
		idea = { "Glitchkat10" },
		code = { "Glitchkat10" }
	}
}

SMODS.Joker {
	key = "evil_bulgoe",
	config = { extra = { chips = 2.7 } },
	rarity = "cry_cursed",
	atlas = "crp_jokers",
	pos = { x = 8, y = 2 },
	cost = 0,
	blueprint_compat = true,
	demicolon_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { lenient_bignum(card.ability.extra.chips) } }
	end,
	calculate = function(self, card, context)
		if (context.joker_main) or context.forcetrigger then
			return {
				message = "÷" .. lenient_bignum(card.ability.extra.chips) .. " Chips",
				Xchip_mod = 1 / lenient_bignum(card.ability.extra.chips),
				colour = G.C.CHIPS,
			}
		end
	end,
	crp_credits = {
		idea = { "Grahkon", "Glitchkat10" },
		art = { "Lexi" },
		code = { "Glitchkat10" }
	}
}

SMODS.Joker {
	key = "twoforsome",
	config = { extra = { hand_size = 2, consumeableslots = 2, boosterpackslots = 2 } },
	rarity = 3,
	atlas = "crp_placeholders",
	pos = { x = 4, y = 0 },
	cost = 8,
	blueprint_compat = false,
	demicolon_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.hand_size, card.ability.extra.consumeableslots, card.ability.extra.boosterpackslots } }
	end,
	add_to_deck = function(self, card, from_debuff)
		SMODS.change_booster_limit(card.ability.extra.boosterpackslots)
		G.hand:change_size(card.ability.extra.hand_size)
		G.consumeables.config.card_limit = G.consumeables.config.card_limit + card.ability.extra.consumeableslots
	end,
	remove_from_deck = function(self, card, from_debuff)
		SMODS.change_booster_limit(-card.ability.extra.boosterpackslots)
		G.hand:change_size(-card.ability.extra.hand_size)
		G.consumeables.config.card_limit = G.consumeables.config.card_limit - card.ability.extra.consumeableslots
	end,
	crp_credits = {
		idea = { "aqrlr" },
		code = { "ScarredOut" }
	}
}

SMODS.Joker {
	key = "dumpster_diver",
	config = { extra = { create = 2, rare_create = 1, odds = 20 } },
	rarity = 3,
	atlas = "crp_placeholders",
	pos = { x = 4, y = 0 },
	cost = 8,
	blueprint_compat = true,
	demicolon_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { lenient_bignum(card.ability.extra.create), cry_prob(card.ability.cry_prob, card.ability.extra.odds, card.ability.cry_rigged), card.ability.extra.odds, lenient_bignum(card.ability.extra.rare_create) } }
	end,
	calculate = function(self, card, context)
		if (context.end_of_round and not context.individual and not context.repetition) or context.forcetrigger then
			local odds = card.ability.extra.odds or 20
			local create = lenient_bignum(card.ability.extra.create)
			local rare_create = lenient_bignum(card.ability.extra.rare_create)
			local roll = pseudorandom("crp_dumpster_diver")
			local chance = cry_prob(card.ability.cry_prob, odds, card.ability.cry_rigged) / odds
			if roll < chance or context.forcetrigger then
				G.GAME.joker_buffer = G.GAME.joker_buffer + rare_create
				for i = 1, rare_create do
					local rare = create_card("Joker", G.jokers, nil, 3, nil, nil, nil, "crp_dumpster_diver")
					rare:set_edition({ negative = true })
					rare:add_to_deck()
					G.jokers:emplace(rare)
					rare:start_materialize()
				end
				return {
					message = "+" .. lenient_bignum(card.ability.extra.rare_create) .. " Rare Joker",
					colour = G.C.RARITY[3],
				}
			else
				G.GAME.joker_buffer = G.GAME.joker_buffer + create
				for i = 1, create do
					local trash = create_card("Joker", G.jokers, nil, "crp_trash", nil, nil, nil, "crp_dumpster_diver")
					trash:set_edition({ negative = true })
					trash:add_to_deck()
					G.jokers:emplace(trash)
					trash:start_materialize()
				end
				return {
					message = "+" .. lenient_bignum(card.ability.extra.create) .. " Trash Jokers",
					colour = HEX("606060"),
				}
			end
		end
	end,
	crp_credits = {
		idea = { "Glitchkat10" },
		code = { "Glitchkat10" }
	}
}

SMODS.Joker {
	key = "glitchkat10",
	config = { extra = { mult = 1, chips = 1, Xmult = 1, Xchips = 1 } },
	rarity = "crp_self-insert",
	atlas = "crp_jokers",
	pos = { x = 5, y = 1 },
	cost = 0,
	blueprint_compat = true,
	demicolon_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { lenient_bignum(card.ability.extra.chips), lenient_bignum(card.ability.extra.mult), lenient_bignum(card.ability.extra.Xchips), lenient_bignum(card.ability.extra.Xmult) } }
	end,
	calculate = function(self, card, context)
		if (context.joker_main) or context.forcetrigger then
			local quotes = {
				"yea i made the mod",
				"i'm so tuff",
				"hello",
				"i see.",
				"graveyarded!",
				"approved!",
				"alr bro",
				"in the big '27 :wilted_rose:",
				"dysthymia",
				"bulgoe",
				"bulgoe's hiking journey",
				"bulgoe prize",
				"bulgoeship card",
				"https://discord.gg/Jk9Q9usrNy",
				"my name is glitchkat10. i made the cryptposting.",
				"i'm cryptposting it",
				"\"i have no idea why this isn't affecting the speed rn\"",
				"my favorite song is nanachi by mrkolii",
				"can we ban grahkon he's taking up too much space",
				"ultrakill",
				"joe kerr",
				"i also coded for ascensio",
				"i also coded for cryptid",
				"i also made glitch's backlog",
				"i also suggestions for cryptid",
				"i also drew for ascensio",
				"i also made suggestions for ascensio",
				"polterworx (formerly twitter)",
				"tbh i work more on cryptposting than poker",
				"icl ts pmo sm :broken_heart:",
				"i use vs code for coding",
				"i use zen for browsing",
				"i use aseprite for drawing",
				"hey guys, did you know that in terms of male human and female pokémon breeding, vaporeon is the most compatible pokémon for humans? not only are they in the field egg group, which is mostly comprised of mammals, vaporeon are an average of 3\"03' tall and 63.9 pounds, this means they're large enough to be able handle human dicks, and with their impressive base stats for hp and access to acid armor, you can be rough with one. due to their mostly water based biology, there's no doubt in my mind that an aroused vaporeon would be incredibly wet, so wet that you could easily have sex with one for hours without getting sore. they can also learn the moves attract, baby-doll eyes, captivate, charm, and tail whip, along with not having fur to hide nipples, so it'd be incredibly easy for one to get you in the mood. with their abilities water absorb and hydration, they can easily recover from fatigue with enough water. no other pokémon comes close to this level of compatibility. also, fun fact, if you pull out enough, you can make your vaporeon turn white. vaporeon is literally built for human dick. ungodly defense stat+high hp pool+acid armor means it can take cock all day, all shapes and sizes and still come for more.",
				"what the smegma",
				"me (6'1\") when a burglar (balatro reference) tries to steal my feminist literature (6'1\" btw)",
				"metal pipe sound effect",
				"collecting \"code = { \"glitchkat10\" }\" like the cuts on my body",
				"what the freak bro",
				"schedule 1 is peam",
				"this will be PEAM",
				"#f04360",
				"#322136",
				"#4c2f4d",
				"#613e5f",
				"#784d75",
				"#855a82",
				"#bd1d3a",
				"i completely made the overloaded edition",
				"i completely made the four-dimensional edition",
				"attempt to compare number with table",
				"mythic tag when",
				"release when",
				"i'm a guy btw",
				"abysmal",
				"self-insert",
				"exomythic",
				"trash",
				"i'm not saying colon three",
				"2common4me",
				"uncommon 2",
				"unrare",
				"rare 2",
				"meat",
				"m",
				"cipe",
				"awesome",
				"exotic 2",
				"mythic",
				"exomythic",
				"2exomythic4me",
				"22exomythic4mecipe",
				"exomythicepicawesomeuncommon2mexotic22exomythic4mecipe",
				"exomythicepicawesomeuncommon2mexotic2gigammegaalphaomnipotranscendant2exomythic4mecipe",
				"supa rare",
				"all",
				"again!",
				"nope!",
				"this is quote 80",
				"9^2",
				"playerrkillerr",
				"illegal",
				"banned",
				"poker is like 12 ngl",
				"just the two of us",
				"bulgoe",
				"hd bulgoe",
				"bulgoeship card has gained ^^0.1 mult",
				"*you're",
				"*your",
				"if only we could",
				"i don't feel like it today tbh",
				"oops",
				"that moment when you accidentally delete joker.lua",
				"font: arial, size: 10, text color: \"custom color #f04360, close to light red 1,\" highlight color: \" custom color #4c2f4d, close to dark gray 4,\" text: \"font: arial, size: 10, text color: \"custom color #f04360, close to light red 1,\" highlight color: \" custom color #4c2f4d, close to dark gray 4,\" text: [recursive]\"",
				"cryptposting idea document (cid)",
				"https://docs.google.com/document/d/1toiOWh2qfouhZYUSiBEgHxU91lbzgvMfR46bShg67Qs/edit?usp=sharing",
				"a collection of the cryptid community's unfunniest shitposts",
				"https://github.com/kierkat10/Cryptposting",
				"this is the last quote in the list of glitchkat10 quotes"
			}
			local quote = quotes[math.random(#quotes)]
            return {
	            chip_mod = -lenient_bignum(card.ability.extra.chips),
                message =  "-" .. lenient_bignum(card.ability.extra.chips),
                colour = G.C.CHIPS,
	            extra = {
                    mult_mod = -lenient_bignum(card.ability.extra.mult),
                    message =  "-" .. lenient_bignum(card.ability.extra.mult) .. " Mult",
                    colour = G.C.MULT,
                    extra = {
		                Xchip_mod = 1 / lenient_bignum(card.ability.extra.Xchips),
                        message = "÷" .. lenient_bignum(card.ability.extra.Xchips),
                        colour = G.C.CHIPS,
                        extra = {
		                    Xmult_mod = 1 / lenient_bignum(card.ability.extra.Xmult),
                            message = "÷" .. lenient_bignum(card.ability.extra.Xmult) .. " Mult",
                            colour = G.C.MULT,
                            extra = {
                                message = quote,
                                colour = G.C.RARITY["crp_self-insert"]
                            }
                        }
                    }
	            }
            }
		end
	end,
    in_pool = function(self, args)
		return true, { allow_duplicates = true }
	end,
	crp_credits = {
		idea = { "Glitchkat10" },
		art = { "Glitchkat10" },
		code = { "Glitchkat10" }
	}
}

SMODS.Joker {
	key = "gudusername",
	config = { immutable = { Xchips = 0.99, Xmult = 0.99, Echips = 0.99, Emult = 0.99, EEchips = 0.99, EEmult = 0.99, EEEchips = 0.99, EEEmult = 0.99 } },
	rarity = "crp_self-insert",
	atlas = "crp_jokers",
	pos = { x = 8, y = 3 },
	cost = 0,
	blueprint_compat = true,
	demicolon_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { lenient_bignum(card.ability.immutable.Xchips), lenient_bignum(card.ability.immutable.Xmult), lenient_bignum(card.ability.immutable.Echips), lenient_bignum(card.ability.immutable.Emult), lenient_bignum(card.ability.immutable.EEchips), lenient_bignum(card.ability.immutable.EEmult), lenient_bignum(card.ability.immutable.EEEchips), lenient_bignum(card.ability.immutable.EEEmult), } }
	end,
	calculate = function(self, card, context)
		if (context.joker_main) or context.forcetrigger then
			local quotes = {
				"Pls no sell me",
                "*Pushes you into a road cutely*"
			}
			local quote = quotes[math.random(#quotes)]
			return {
				Xchip_mod = lenient_bignum(card.ability.immutable.Xchips),
				message = "X" .. lenient_bignum(card.ability.immutable.Xchips),
				colour = G.C.CHIPS,
				extra = {
					Xmult_mod = lenient_bignum(card.ability.immutable.Xmult),
					message = "X" .. lenient_bignum(card.ability.immutable.Xmult) .. " Mult",
					colour = G.C.MULT,
					extra = {
						Echips_mod = lenient_bignum(card.ability.immutable.Echips),
						message = "^" .. lenient_bignum(card.ability.immutable.Echips),
						colour = G.C.DARK_EDITION,
						extra = {
							Emult_mod = lenient_bignum(card.ability.immutable.Emult),
							message = "^" .. lenient_bignum(card.ability.immutable.Emult) .. " Mult",
							colour = G.C.DARK_EDITION,
							extra = {
								EEchips_mod = lenient_bignum(card.ability.immutable.EEchips),
								message = "^^" .. lenient_bignum(card.ability.immutable.EEchips),
								colour = G.C.DARK_EDITION,
								extra = {
									EEmult_mod = lenient_bignum(card.ability.immutable.EEmult),
									message = "^^" .. lenient_bignum(card.ability.immutable.EEmult) .. " Mult",
									colour = G.C.DARK_EDITION,
									extra = {
										EEEchips_mod = lenient_bignum(card.ability.immutable.EEEchips),
										message = "^^^" .. lenient_bignum(card.ability.immutable.EEEchips),
										colour = G.C.EDITION,
										extra = {
											EEEmult_mod = lenient_bignum(card.ability.immutable.EEEmult),
											message = "^^^" .. lenient_bignum(card.ability.immutable.EEEmult) .. " Mult",
											colour = G.C.EDITION,
											extra = {
												message = quote,
												colour = G.C.RARITY["crp_self-insert"]
											}
										}
									}
								}
							}
						}
					}
				}
			}
		end
	end,
    in_pool = function(self, args)
		return true, { allow_duplicates = true }
	end,
	crp_credits = {
		idea = { "Glitchkat10" },
		art = { "GudUsername" },
		code = { "Glitchkat10" }
	}
}

SMODS.Joker {
	key = "septingentiquinvigintation_stevie",
	config = { immutable = { arrows = 723 }, extra = { mantissa = 1e111, placebo = 1.1 } },
	rarity = "crp_exomythicepicawesomeuncommon2mexotic22exomythic4mecipe",
	atlas = "crp_placeholders",
	pos = { x = 12, y = 0 },
	cost = 1600,
	blueprint_compat = true,
	demicolon_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { lenient_bignum(card.ability.extra.placebo) } }
	end,
	calculate = function(self, card, context)
		if (context.joker_main) or context.forcetrigger then
			return {
				hypermult_mod = {lenient_bignum(card.ability.immutable.arrows), lenient_bignum(card.ability.extra.mantissa)},
				message = "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^" .. lenient_bignum(card.ability.extra.placebo) .. " Mult",
				colour = G.C.EDITION
			}
		end
	end,
	crp_credits = {
		idea = { "PurplePickle" },
		code = { "Glitchkat10" }
	}
}

--[[
 SMODS.Joker {
	key = "shit",
	config = { extra = { create = 1 } },
	rarity = 3,
	atlas = "crp_placeholders",
	pos = { x = 4, y = 0 },
	cost = 8,
	blueprint_compat = true,
	demicolon_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { lenient_bignum(card.ability.extra.create) } }
	end,
	calculate = function(self, card, context)
		if (context.end_of_round and not context.individual and not context.repetition) or context.forcetrigger then
			local create = lenient_bignum(card.ability.extra.create)
			G.GAME.joker_buffer = G.GAME.joker_buffer + create
			for i = 1, create do
				local trash = create_card("Joker", G.jokers, nil, "crp_self-insert", nil, nil, nil, "crp_shit")
				trash:set_edition({ negative = true })
				trash:add_to_deck()
				G.jokers:emplace(trash)
				trash:start_materialize()
			end
			return {
				message = "+" .. lenient_bignum(card.ability.extra.create) .. " Self-Insert Joker",
				colour = G.C.RARITY["crp_self-insert"],
			}
		end
	end,
	crp_credits = {
		idea = { "Glitchkat10" },
		code = { "Glitchkat10" }
	}
}
--]]
----------------------------------------------
------------MOD CODE END----------------------
