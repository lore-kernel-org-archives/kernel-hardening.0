Message-ID: <1496498027.22395.1.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Sat, 03 Jun 2017 09:53:47 -0400
In-Reply-To: <20170603113007.GA1544@grsecurity.net>
References: <20170603113007.GA1544@grsecurity.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Stop the plagiarism
To: Brad Spengler <spender@grsecurity.net>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

> "a value linux-hardened and grsecurity have used for a long time now"
> Rik, you're giving credit to a project that didn't even exist a couple
> weeks ago, yet they've somehow used it "for a long time", even though
> it only exists there because it was copy+pasted from grsecurity?

You're going out of the way to misinterpret that wording.

You don't document where changes came from in the PaX and grsecurity
patches. There's code written by other people in there, and there's
neither a Git repository crediting them in a commit history or with a
few exceptions inline credit given to those people. When I extract
something from the PaX or grsecurity patches or base code on the ideas
there, I can't state with certainty who authored the code. I've been
stating 'extracted from PaX' or 'extracted from grsecurity' for code not
part of PaX and documenting changes from the implementation there. Code
being from PaX or grsecurity isn't necessarily 'code authored by the PaX
Team or Brad Spengler'. It could be code written by Emese, minipli,
someone else who contributed code to you or a patch that you took from
elsewhere that was ignored / rejected by upstream. How is anyone else
supposed to know?

People were given credit in the original PaX changelogs at the top of
the patches in most cases but all but the latest patch for kernel
branches was taken down. Similarly, the grsecurity changelogs gave
credit but are all taken down and it's not like many people actually
looked at those at the time.

For example, the MODIFY_LDT sysctl in grsecurity is someone else's code.
It isn't stated in grsecurity where it came from. That's true to an even
larger extent when it comes to ideas rather than implementation. You
give credit to Willy Tarreau for NO_SIMULT_CONNECT but not that
MODIFY_LDT one, and I can think of a bunch of other examples.

It looks to me like people contributing these changes upstream have been
more consistently giving credit than the grsecurity patches do. When the
grsecurity patches are not mentioning who wrote changes or came up with
the idea how are people supposed to know who to credit... ? It applies
to an even larger extent to ideas rather than code. Most of the code and
ideas there are from the PaX Team and yourself, sure, but not all.

Maybe stop calling me a plagiarist when I'm trying my best to give
credit and actually do a better job than you do in practice.

>   Is
> that what we do now, credit plagiarists instead of the actual authors
> of
> the work?  Sorry, but the "work" of struggling to understand code that
> isn't yours doesn't suddenly make it your code.

These commits reference the PaX implementation there. You've told me to
stop doing that but rather reference the specific PaX version in the
future which I intend to do. 

https://github.com/thestinger/linux-hardened/commit/4c355f98910e01256ee2b01dd1a02ac08dd316b2.patch
https://github.com/thestinger/linux-hardened/commit/711e5650589c9d3c99706c6a5d52d2659519dc74.patch
https://github.com/thestinger/linux-hardened/commit/cd9cdbff4bc69d2e88b37d106e6ee8ef33a3a1b8.patch

The Linux kernel is GPL2 and grsecurity is a derivative work. I'm not
sure how it's plagiarism to tweak the upstream implementation of ASLR
based on the PaX implementation while describing the differences with
the PaX implementation which I'm trying to do in depth:

Making the stack entropy depend on the mainline mmap sysctl isn't based
on PaX and therefore doesn't reference it.

I needed to move the ET_DYN base on arm64 to 4G because the address
range overlapped when using the sysctl for the stack which I noticed in
testing. I then did x86_64 and the 32-bit architectures. I don't know
how the values were chosen in PaX and they don't meet the compatibility
requirements that I need on 64-bit where there are projects using 32-bit 
pointers by mapping certain things in the lower 32 bits of the address
space and they cannot necessarily cope with any fragmentation there.

https://gist.github.com/thestinger/b43b460cfccfade51b5a2220a0550c35
