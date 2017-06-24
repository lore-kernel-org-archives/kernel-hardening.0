Return-Path: 
 <oss-security-return-22608-ydroneaud=opteya.com@lists.openwall.com>
List-Post: <mailto:oss-security@lists.openwall.com>
List-Help: <mailto:oss-security-help@lists.openwall.com>
List-Unsubscribe: <mailto:oss-security-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:oss-security-subscribe@lists.openwall.com>
Reply-To: oss-security@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAADWXX8JYe-AewtzoY6VBVLPTs+UvnfZst76vL4tccf6x9cY=g@mail.gmail.com>
References: <20170624005003.GB27479@grsecurity.net>
	 <CAADWXX8JYe-AewtzoY6VBVLPTs+UvnfZst76vL4tccf6x9cY=g@mail.gmail.com>
From: Shawn <citypw@gmail.com>
Date: Sat, 24 Jun 2017 23:26:00 +0800
Message-ID: <CABniQZPtHV+-XiHPRUGcDe+KwEd1JpPdcDb2Xn63t2Z_Os6ETQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [oss-security] Re: More CONFIG_VMAP_STACK vulnerabilities,
 refcount_t UAF, and an ignored Secure Boot bypass / rootkit method
Content-Transfer-Encoding: 8bit
To: oss-security@lists.openwall.com
Cc: Brad Spengler <spender@grsecurity.net>, pageexec@freemail.hu, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Linus,

Not sure how you got the conclusion like "Their patches are pure
garbage."( https://www.spinics.net/lists/kernel/msg2540934.html). I'm
wondering why there's a group of ppl called themselves KSPP got paid
by big corps are still trying to copy+paste PaX/Grsecurity to the
upstream if you think it's a garbage? Did you try to tell KSPP guys to
stop their work( cc'ing kernel-hardening mailinglist)? It's so obvious
to see the most security work( more than just a specific OS)
originally done by PaX/Grsecurity:

https://github.com/hardenedlinux/grsecurity-101-tutorials/blob/master/kernel_mitigation.md

And my customers has been suffering from your philosophical ideas of
"A bug is bug" for too long. I really respect your contributions(
linux kernel/git) to the FLOSS world. But even the open source king
can't change the truth:

https://github.com/hardenedlinux/grsecurity-101-tutorials/blob/master/kernel_vuln_exp.md

btw: You didn't answer Brad's question.


On Sat, Jun 24, 2017 at 9:04 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Jun 23, 2017 at 5:50 PM, Brad Spengler <spender@grsecurity.net> wrote:
>>
>> BTW, we're happy to go toe-to-toe with you here in public on actual facts
>> instead of pathetic ad hominems.
>
> Quite frankly, I'd much rather see *you* actually send in patches that
> are acceptable for inclusion, something you've never done.
>
> As it is, other people have tried to clean up parts of the grsecurity
> patches, and tried to make them acceptable.
>
> Wouldn't it be nice if you actually tried to make the baseline actually better?
>
> Please.
>
>                 Linus



-- 
GNU powered it...
GPL protect it...
God blessing it...

regards
Shawn
