Reply-To: kernel-hardening@lists.openwall.com
References: <20161206062800.21800-1-andrew.donnellan@au1.ibm.com>
 <20161206062800.21800-3-andrew.donnellan@au1.ibm.com>
 <5849716A.32374.136DAAC@pageexec.freemail.hu>
 <CAGXu5jKrU5GR3KDb9M-vtSpY+aRm2B0vGpahVYLtFTWs=g7Big@mail.gmail.com>
From: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Date: Fri, 9 Dec 2016 13:48:26 +1100
MIME-Version: 1.0
In-Reply-To: <CAGXu5jKrU5GR3KDb9M-vtSpY+aRm2B0vGpahVYLtFTWs=g7Big@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Message-Id: <f5ea8825-532c-93bd-d51d-6ec1e541fae6@au1.ibm.com>
Subject: [kernel-hardening] Re: [PATCH 3/3] powerpc: enable support for GCC plugins
To: Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>
Cc: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Emese Revfy <re.emese@gmail.com>, LKML <linux-kernel@vger.kernel.org>, linux-kbuild <linux-kbuild@vger.kernel.org>, Brad Spengler <spender@grsecurity.net>, Michal Marek <mmarek@suse.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 09/12/16 05:06, Kees Cook wrote:
>> i don't think that this is the right approach. there's a general and a special
>> issue here, both of which need different handling.
>>
>> the general problem is to detect problems related to gcc plugin headers and
>> notify the users about solutions. emitting various messages from a Makefile
>> is certainly not a scalable approach, just imagine how it will look when the
>> other 30+ archs begin to add their own special cases... if anything, they
>> should be documented in Documentation/gcc-plugins.txt (or a new doc if it
>> grows too big) and the Makefile message should just point at it.

I think I agree in principle - Makefiles are already unreadable enough 
without a million special cases.

>> as for the solutions, the general advice should enable the use of otherwise
>> failing gcc versions instead of forcing updating to new ones (though the
>> latter is advisable for other reasons but not everyone's in the position to
>> do so easily). in my experience all one needs to do is manually install the
>> missing files from the gcc sources (ideally distros would take care of it).

If someone else is willing to write up that advice, then great.

>> the specific problem addressed here can (and IMHO should) be solved in
>> another way: remove the inclusion of the offending headers in gcc-common.h
>> as neither tm.h nor c-common.h are needed by existing plugins. for background,

We can't build without tm.h: http://pastebin.com/W0azfCr0

And we get warnings without c-common.h: http://pastebin.com/Aw8CAj10

>> as for the location of c-common.h, upstream gcc moved it under c-family in
>> 2010 after the release of 4.5, so it should be where gcc-common.h expects
>> it and i'm not sure how it ended up at its old location for you.
>
> That is rather odd. What distro was the PPC test done on? (Or were
> these manually built gcc versions?)

These were all manually built using a script running on a Debian box. 
Installing precompiled distro versions of rather old gccs would have 
been somewhat challenging. I've just rebuilt 4.6.4 to double check that 
I wasn't just seeing things, but it seems that it definitely is still 
putting c-common.h in the old location.

-- 
Andrew Donnellan              OzLabs, ADL Canberra
andrew.donnellan@au1.ibm.com  IBM Australia Limited
