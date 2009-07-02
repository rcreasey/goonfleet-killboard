Factory.define :kill do |f|
  f.killmail "#{DateTime.now.strftime("%Y-%m-%d %H:%M:%S")}

Victim: cell187
Alliance: NONE
Corp: ClanKillers
Destroyed: Kestrel
System: Y9G-KS
Security: 0.0

Involved parties:

Name: Tarei (laid the final blow)
Security: -0.3
Alliance: NONE
Corp: GoonFleet
Ship: Caracal
Weapon: Bloodclaw Light Missile I

Destroyed items:

Mark I Modified SS Nanofiber Structure

Heat Dissipation Field I

Serpent F.O.F. Light Missile I, Qty: 10166 (Cargo)

Exterminator F.O.F. Light Missile I, Qty: 36
"
end

Factory.define :alliance do |f|
  f.sequence(:name) {|n| "Alliance #{n}"}
  f.sequence(:short_name) {|n| "ALLI#{n}"}
  f.eve_id "#{rand(9)}"
  f.executor_corp_id "#{rand(9)}"
  f.start_date "#{Time.now}"
end