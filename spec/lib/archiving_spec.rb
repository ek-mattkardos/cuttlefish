require "spec_helper"

describe Archiving do
  it do
    team = Team.create!
    app = team.apps.create!(
      id: 2,
      name: "Planning Alerts",
      from_domain: "planningalerts.org.au"
    )

    from_address = Address.create!(
      id: 12,
      text: "bounces@planningalerts.org.au"
    )
    to_address = Address.create!(
      id: 13,
      text: "foo@gmail.com"
    )
    email = app.emails.create!(
      id: 1753541,
      from_address: from_address,
      data_hash: "aa126db79482378ce17b441347926570228f12ef",
      message_id: "538ef46757549_443e4bb0f901893332@kedumba.mail",
      subject: "1 new planning application"
    )
    link1 = Link.create!(
      id: 123,
      url: "http://www.planningalerts.org.au/alerts/abc1234/area"
    )
    link2 = Link.create!(
      id: 321,
      url: "http://www.planningalerts.org.au/alerts/abc1234/unsubscribe"
    )
    click_event = ClickEvent.create!(
      user_agent: "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Firefox/24.0",
      ip: "1.2.3.4",
      created_at: "2014-06-04T20:33:53.000+10:00"
    )
    delivery = Delivery.create!(
      id: 5,
      email: email,
      address: to_address,
      created_at: "2014-06-04T20:26:51.000+10:00",
      updated_at: "2014-06-04T20:26:55.000+10:00",
      sent: true,
      status: "delivered",
      open_tracked: true,
      postfix_queue_id: "38B72370AC41"
    )
    delivery.open_events.create!(
      user_agent: "Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.9.0.7) Gecko/2009021910 Firefox/3.0.7 (via ggpht.com GoogleImageProxy)",
      ip: "2.3.4.5",
      created_at: "2014-10-06T16:05:52.000+11:00"
    )
    delivery.delivery_links.create!(
      link: link1,
      click_events: []
    )
    delivery.delivery_links.create!(
      link: link2,
      click_events: [click_event]
    )
    delivery.postfix_log_lines.create!(
      time: "2014-06-04T20:26:53.000+10:00",
      relay: "gmail-smtp-in.l.google.com[173.194.79.26]:25",
      delay: "1.7",
      delays: "0.05/0/0.58/1",
      dsn: "2.0.0",
      extended_status: "sent (250 2.0.0 OK 1401877617 bh2si4687161pbb.204 - gsmtp)"
    )

    s1 = Archiving.serialise(delivery)
    delivery.destroy
    delivery = Archiving.deserialise(s1)
    s2 = Archiving.serialise(delivery)
    expect(s1).to eq s2
  end
end
