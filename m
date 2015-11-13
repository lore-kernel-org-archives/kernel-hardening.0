Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Fri, 13 Nov 2015 09:55:35 +0100
From: HacKurx <hackurx@gmail.com>
In-Reply-To: <56459A43.3020400@gmail.com>
References: <CAGXu5jJ3FgxXK9WuOLRwnEq=y4dS+CTm+WQBxWe3sYZ7e9p6Gg@mail.gmail.com>
 <n1iirh$q7o$1@ger.gmane.org>
 <CAGXu5j+ponF+a3aoCnLqEVfBy545BsxT4w=8KGikNCb_24ZgyQ@mail.gmail.com>
 <n1khkt$lc7$1@ger.gmane.org> <87h9kvze0o.fsf@rasmusvillemoes.dk>
 <20151109103315.GB19735@chrystal.uk.oracle.com>
 <87bnb3ou1c.fsf@rasmusvillemoes.dk>
 <CAGXu5jLST1eoNU3YF-kLnTOHcq6iyD8YbS=oGr+3p2eFsz-X=A@mail.gmail.com>
 <c3c5f9857a782b1d4405272f08ce5b3d@opensec.fr>
 <29498.1447107624@turing-police.cc.vt.edu>
 <d5b6cf123db60902d480129396d0a8fb@opensec.fr> <56459A43.3020400@gmail.com>
Message-ID: <4f67a4d7a81416aab522503b67ca3107@opensec.fr>
Subject: Re: [kernel-hardening] Binary blobs
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Le 2015-11-13 09:07, Daniel Micay a écrit :
>> all hardened options for GCC.
> 
> Well, you probably can't get away with -fsanitize=undefined
> -fsanitize-undefined-trap-on-error yet (object-size and
> signed-integer-overflow checks specifically). I know what you mean
> though :).

Yes you are right, it is easy to have a warning but not a correction.

But with mprotect and:
CFLAGS="-fstack-protector --param=ssp-buffer-size=4 -Wformat 
-Wformat-security -Werror=format-security"
CPPFLAGS="-D_FORTIFY_SOURCE=2"
LDFLAGS="-Wl,-z,relro"

It's already better than the official release :D

-- 
Best regards,
