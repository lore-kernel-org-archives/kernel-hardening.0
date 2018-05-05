Date: Sat, 5 May 2018 20:51:45 +0200
From: Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH] net: dsa: drop some VLAs in switch.c
Message-ID: <20180505185145.GB32630@lunn.ch>
References: <1520970647-19587-1-git-send-email-s.mesoraca16@gmail.com>
 <87fu5321du.fsf@weeman.i-did-not-set--mail-host-address--so-tickle-me>
 <b948ef55-8b16-fee4-b22f-4c6d09fea0cf@gmail.com>
 <CAJHCu1+V+khxvzhQdG=mo960b5ayiQcSaoMnm9A__51JdWkdig@mail.gmail.com>
 <20180505153905.GA30439@lunn.ch>
 <CAGXu5j+x3LU6ADYtvDiXHjw=wws=jjRzmMk9RC4BwWQYWd47bA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+x3LU6ADYtvDiXHjw=wws=jjRzmMk9RC4BwWQYWd47bA@mail.gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: Salvatore Mesoraca <s.mesoraca16@gmail.com>, Florian Fainelli <f.fainelli@gmail.com>, Vivien Didelot <vivien.didelot@savoirfairelinux.com>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Network Development <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

> > You could make the bitmap part of the dsa_switch structure. This is
> > allocated by dsa_switch_alloc() and is passed the number of ports.
> > Doing the allocation there means you don't need to worry about it
> > failing in dsa_switch_mdb_add() or dsa_switch_vlan_add().
> 
> Are dsa_switch_mdb_add() and dsa_switch_vlan_add() guaranteed to be
> single-threaded?

Yes, that is the interesting question here.... against each other, or
themselves?

They are called from a notifier chain. It is the same notifier chain
for both dsa_switch_mdb_add() and dsa_switch_vlan_add().

notifier_call_chain() itself appears to not provide any guarantees
about the same handler being called in parallel.

It is dsa_port_notify() which is calling the notifier_call_chain().
This is being called by both dsa_port_vlan_add() and
dsa_port_mdb_add() in dsa_slave_port_obj_add(). This is a switchdev
op. switchdev_port_obj_add_now() does have ASSERT_RTNL(); So that
should serialize everything.

     Andrew
