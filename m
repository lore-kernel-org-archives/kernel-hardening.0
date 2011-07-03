Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <4E0FC08C.8050600@gentoo.org>
Date: Sat, 02 Jul 2011 21:06:20 -0400
From: "Anthony G. Basile" <blueness@gentoo.org>
MIME-Version: 1.0
References: <20110626183321.GA3867@albatros> <20110629182505.GC14873@openwall.com> <20110629183728.GA8163@albatros> <20110629194339.GA15379@openwall.com>
In-Reply-To: <20110629194339.GA15379@openwall.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] overview of PaX features
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 06/29/2011 03:43 PM, Solar Designer wrote:
> Vasiliy,
> 
> On Wed, Jun 29, 2011 at 10:37:28PM +0400, Vasiliy Kulikov wrote:
>> That's not only about old apps, but also a default relaxed policy for
>> the toolchain:
>>
>> http://www.gentoo.org/proj/en/hardened/gnu-stack.xml
> 
> Of course.  In my experience, most programs that currently get
> executable stack actually don't need it.
> 

Ditto.  When we couldn't fix the source code, we used to use execstack
from the prelink package to remove the X flag from PT_GNU_STACK phdrs.
Recently I wrote fix-gnustack.c to avoid all the extra prelink stuff [1]
and we're using that now.

Ref.

   [1] http://git.overlays.gentoo.org/gitweb/?p=proj/elfix.git;a=summary

-- 
Anthony G. Basile, Ph.D.
Gentoo Linux Developer [Hardened]
E-Mail    : blueness@gentoo.org
GnuPG FP  : 8040 5A4D 8709 21B1 1A88  33CE 979C AF40 D045 5535
GnuPG ID  : D0455535
