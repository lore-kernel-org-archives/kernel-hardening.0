MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20180505153905.GA30439@lunn.ch>
References: <1520970647-19587-1-git-send-email-s.mesoraca16@gmail.com>
 <87fu5321du.fsf@weeman.i-did-not-set--mail-host-address--so-tickle-me>
 <b948ef55-8b16-fee4-b22f-4c6d09fea0cf@gmail.com> <CAJHCu1+V+khxvzhQdG=mo960b5ayiQcSaoMnm9A__51JdWkdig@mail.gmail.com>
 <20180505153905.GA30439@lunn.ch>
From: Kees Cook <keescook@chromium.org>
Date: Sat, 5 May 2018 11:22:20 -0700
Message-ID: <CAGXu5j+x3LU6ADYtvDiXHjw=wws=jjRzmMk9RC4BwWQYWd47bA@mail.gmail.com>
Subject: Re: [PATCH] net: dsa: drop some VLAs in switch.c
Content-Type: text/plain; charset="UTF-8"
To: Andrew Lunn <andrew@lunn.ch>
Cc: Salvatore Mesoraca <s.mesoraca16@gmail.com>, Florian Fainelli <f.fainelli@gmail.com>, Vivien Didelot <vivien.didelot@savoirfairelinux.com>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Network Development <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, May 5, 2018 at 8:39 AM, Andrew Lunn <andrew@lunn.ch> wrote:
> On Sat, May 05, 2018 at 12:36:36PM +0200, Salvatore Mesoraca wrote:
>> 2018-03-13 21:06 GMT+01:00 Florian Fainelli <f.fainelli@gmail.com>:
>> > On 03/13/2018 12:58 PM, Vivien Didelot wrote:
>> >> Hi Salvatore,
>> >>
>> >> Salvatore Mesoraca <s.mesoraca16@gmail.com> writes:
>> >>
>> >>> dsa_switch's num_ports is currently fixed to DSA_MAX_PORTS. So we avoid
>> >>> 2 VLAs[1] by using DSA_MAX_PORTS instead of ds->num_ports.
>> >>>
>> >>> [1] https://lkml.org/lkml/2018/3/7/621
>> >>>
>> >>> Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
>> >>
>> >> NAK.
>> >>
>> >> We are in the process to remove hardcoded limits such as DSA_MAX_PORTS
>> >> and DSA_MAX_SWITCHES, so we have to stick with ds->num_ports.
>> >
>> > Then this means that we need to allocate a bitmap from the heap, which
>> > sounds a bit superfluous and could theoretically fail... not sure which
>> > way is better, but bumping the size to DSA_MAX_PORTS definitively does
>> > help people working on enabling -Wvla.
>>
>> Hi Florian,
>>
>> Should I consider this patch still NAKed or not?
>> Should I resend the patch with some modifications?
>
> Hi Salvatore
>
> We have been removing all uses of DSA_MAX_PORTS. I don't particularly
> like arbitrary limits on how many ports a switch can have, or how many
> switches a board can have.
>
> So i would prefer to not use DSA_MAX_PORTS here.
>
> You could make the bitmap part of the dsa_switch structure. This is
> allocated by dsa_switch_alloc() and is passed the number of ports.
> Doing the allocation there means you don't need to worry about it
> failing in dsa_switch_mdb_add() or dsa_switch_vlan_add().

Are dsa_switch_mdb_add() and dsa_switch_vlan_add() guaranteed to be
single-threaded?

-Kees

-- 
Kees Cook
Pixel Security
