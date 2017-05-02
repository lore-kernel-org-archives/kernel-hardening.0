MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 02 May 2017 18:38:22 +0200
From: David Gens <david.gens@cs.tu-darmstadt.de>
In-Reply-To: <845fa6c374b0a470eb298da3ec6fc224@openmailbox.org>
References: <845fa6c374b0a470eb298da3ec6fc224@openmailbox.org>
Message-ID: <c386915a90174a5b642e5da58bfe96e5@cs.tu-darmstadt.de>
Subject: Re: [kernel-hardening] Re: It looks like there will be no more public
 versions of PaX and Grsec.
To: bancfc@openmailbox.org
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 2017-05-02 16:22, bancfc@openmailbox.org wrote:
> Hi David, I read your paper [1] about how RAP wouldn't defend against
> data-only attacks. Do you plan on contributing your PT-Rand mitigation
> to KSPP?
> 
> That was never mentioned in the grsec RAP announcements for obvious
> marketing reasons. With KERNSEAL not being public no one can verify
> its effectiveness either.
> 
> 
> [1]
> https://www.internetsociety.org/sites/default/files/ndss2017_05B-4_Davi_paper.pdf

That is certainly doable (and it would be cool), but mainly depends on 
how interesting
such a feature would be for upstream. My impression was that the 
interest is rather limited,
since messing with the linear mapping generally is a big nono (because 
of TLB pressure).

But we're really getting off-topic.

Best,
David
