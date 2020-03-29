#!/usr/bin/env ruby

require 'json'
require_relative '../lib/karabiner.rb'

# TODO:
# [ ] Double/Triple Tap Shorcuts
# [ ] Shift Mode
# [ ] Swtich Mode
#     [ ] Numbers
#

def main
  puts JSON.pretty_generate(
    "title" => "TAP Device (www.tapwithus.com) Emulation (beta)",
    "rules" => [
      # If you want to use other trigger keys for tap mode, just change this above line and run
      #
      # $ make
      #
      # in Terminal to generate your new JSON file at public/json/tap_emulation_mode.json.
      #
      # Copy it to ~/.config/karabiner/assets/complex_modifications then you can enable it in Karabiner-Elements.
      #
      # Modifier keys such as "command", "option" or "control" cannot be used here.
      {
        "description" => "TAP Emulation Trigger [fn as Trigger Key]",
        "manipulators" => generate_tap_trigger("fn"),
      },
      {
        "description" => "TAP Emulation Trigger [` as Trigger Key]",
        "manipulators" => generate_tap_trigger("grave_accent_and_tilde"),
      },
      {
        "description" => "TAP Emulation Mode [njkl; as keys]",
        "manipulators" => generate_tap_mode("n", "j", "k", "l", "semicolon"),
      },
      {
        "description" => "TAP Emulation Mode [vfdsa as keys]",
        "manipulators" => generate_tap_mode("v", "f", "d", "s", "a"),
      },
    ],
  )
end

def generate_tap_trigger(trigger_key)
  [
    {
      "type" => "basic",
      "from" => {
        "key_code" => trigger_key,
        "modifiers" => { "optional" => ["any"] },
      },
      "to_if_held_down" => [
        Karabiner.set_variable("tap_emulation_mode", 1),
      ],
      "to_if_alone" => [
        Karabiner.set_variable("tap_emulation_mode", 1),
      ],
      "conditions" => [
        Karabiner.variable_if('tap_emulation_mode', 0),
      ]
    },
    {
      "type" => "basic",
      "from" => {
        "key_code" => trigger_key,
        "modifiers" => { "optional" => ["any"] },
      },
      "to_if_held_down" => [
        Karabiner.set_variable("tap_emulation_mode", 1),
      ],
      "to_if_alone" => [
        Karabiner.set_variable("tap_emulation_mode", 0),
      ],
      "conditions" => [
        Karabiner.variable_if('tap_emulation_mode', 1),
      ]
    },
  ].flatten
end

def generate_tap_mode(key_t, key_1, key_2, key_3, key_4)
  [
    ## FIVE FINGERS
    # Space
    generate_tap_mode_single_rule([key_t, key_1, key_2, key_3, key_4], "h", []),

    ## FOUR FINGERS
    # One Finger Up (HCVJR)
    generate_tap_mode_single_rule([key_1, key_2, key_3, key_4], "h", []),
    generate_tap_mode_single_rule([key_t, key_2, key_3, key_4], "c", []),
    generate_tap_mode_single_rule([key_t, key_1, key_3, key_4], "v", []),
    generate_tap_mode_single_rule([key_t, key_1, key_2, key_4], "j", []),
    generate_tap_mode_single_rule([key_t, key_1, key_2, key_3], "r", []),

    ## THREE FINGERS
    # Shift, Delete, Swtich
    #generate_tap_mode_single_rule([key_t, key_1, key_2], SHIFT_MODE, []),
    generate_tap_mode_single_rule([key_1, key_2, key_3], "delete_or_backspace", []),
    #generate_tap_mode_single_rule([key_2, key_3, key_4], SWITCH_MODE, []),
    # W, G, X
    generate_tap_mode_single_rule([key_t, key_2, key_4], "w", []),
    generate_tap_mode_single_rule([key_t, key_2, key_3], "g", []),
    generate_tap_mode_single_rule([key_1, key_3, key_4], "x", []),
    # F, Q
    generate_tap_mode_single_rule([key_t, key_1, key_3], "f", []),
    generate_tap_mode_single_rule([key_1, key_2, key_4], "q", []),
    # P, Return
    generate_tap_mode_single_rule([key_t, key_1, key_4], "p", []),
    generate_tap_mode_single_rule([key_t, key_3, key_4], "return_or_enter", []),

    ## TWO FINGERS
    # Two Fingers Together (NTLS)
    generate_tap_mode_single_rule([key_t, key_1], "n", []),
    generate_tap_mode_single_rule([key_1, key_2], "t", []),
    generate_tap_mode_single_rule([key_2, key_3], "l", []),
    generate_tap_mode_single_rule([key_3, key_4], "s", []),
    # Two Fingers Skipping One (DMZ)
    generate_tap_mode_single_rule([key_t, key_2], "d", []),
    generate_tap_mode_single_rule([key_1, key_3], "m", []),
    generate_tap_mode_single_rule([key_2, key_4], "z", []),
    # Two Fingers Skipping Two (KB)
    generate_tap_mode_single_rule([key_t, key_3], "k", []),
    generate_tap_mode_single_rule([key_1, key_4], "b", []),
    # Y
    generate_tap_mode_single_rule([key_t, key_4], "y", []),
    # Vowels
    generate_tap_mode_single_rule([key_t],"a", []),
    generate_tap_mode_single_rule([key_1],"e", []),
    generate_tap_mode_single_rule([key_2],"i", []),
    generate_tap_mode_single_rule([key_3],"o", []),
    generate_tap_mode_single_rule([key_4],"u", []),
  ].flatten
end

def generate_tap_mode_single_rule(from_key_code_array, to_key_code, to_modifier_key_code_array)
  from_simultaneous_keys = []
  from_key_code_array.each do |k|
    from_simultaneous_keys << { "key_code" => k }
  end
  [
    {
      "type" => "basic",
      "from" => {
        "simultaneous" => from_simultaneous_keys,
        "simultaneous_options" => {
          "detect_key_down_uninterruptedly" => true,
        },
        #"modifiers" => { "optional" => ["any"] },
      },
      "to" => [
        {
          "key_code" => to_key_code,
          "modifiers" => to_modifier_key_code_array
        }
      ],
      "conditions" => [
        Karabiner.variable_if('tap_emulation_mode', 1),
      ]
    }
  ]
end
main()
