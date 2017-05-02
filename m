MIME-Version: 1.0
In-Reply-To: <845fa6c374b0a470eb298da3ec6fc224@openmailbox.org>
References: <845fa6c374b0a470eb298da3ec6fc224@openmailbox.org>
From: Mathias Krause <minipli@googlemail.com>
Date: Tue, 2 May 2017 23:28:07 +0200
Message-ID: <CA+rthh_dsHVnDXv2HVBuhC=KWt_szOH-b84z4BQU4EiV0oVP8g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: It looks like there will be no more public
 versions of PaX and Grsec.
To: bancfc@openmailbox.org
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 2 May 2017 at 16:22,  <bancfc@openmailbox.org> wrote:
> Hi David, I read your paper [1] about how RAP wouldn't defend against
> data-only attacks. Do you plan on contributing your PT-Rand mitigation to
> KSPP?
>
> That was never mentioned in the grsec RAP announcements for obvious
> marketing reasons. With KERNSEAL not being public no one can verify its
> effectiveness either.

That's nonsense. RAP's scope was made clear from the beginning,
focusing on control flow integrity, i.e. prevent unintended code
reuse. Just look at [1], page 6 and see for yourself that data-only
attacks are out-of-scope for RAP.

[1] https://pax.grsecurity.net/docs/PaXTeam-H2HC15-RAP-RIP-ROP.pdf

Regards,
Mathias
