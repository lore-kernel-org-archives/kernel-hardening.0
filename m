References: <1497018608-22168-1-git-send-email-alex.popov@linux.com>
From: "Hector Martin \"marcan\"" <marcan@marcan.st>
Message-ID: <dc146cb5-98fc-57f9-e4c8-3e1bd6d78acf@marcan.st>
Date: Tue, 20 Jun 2017 18:06:18 +0900
MIME-Version: 1.0
In-Reply-To: <1497018608-22168-1-git-send-email-alex.popov@linux.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [PATCH RFC v2 1/1] gcc-plugins: Add stackleak
 feature erasing the kernel stack at the end of syscalls
To: Alexander Popov <alex.popov@linux.com>, kernel-hardening@lists.openwall.com, keescook@chromium.org, pageexec@freemail.hu, spender@grsecurity.net, tycho@docker.com
List-ID: <kernel-hardening.lists.openwall.com>

On 09/06/17 23:30, Alexander Popov wrote:
> +/*
> + * Copyright 2011-2017 by the PaX Team <pageexec@freemail.hu>
> + * Licensed under the GPL v2
> + *
> + * Note: the choice of the license means that the compilation process is
> + *       NOT 'eligible' as defined by gcc's library exception to the GPL v3,
> + *       but for the kernel it doesn't matter since it doesn't link against
> + *       any of the gcc libraries

I know this isn't the first time I've mentioned this, but I think it 
bears repeating that, as far as I understand the licensing (IANAL), GCC 
plug-ins licensed as GPLv2 are in violation of the GCC license.

See [1], which says that this plug-in and GCC form a "single combined 
program", and [2], which says that in this case the plug-in must be 
GPL-compatible. Though not specified in this informal FAQ entry, for 
GPLv3-licensed GCC, this obviously means GPLv3-compatible, and the GPLv2 
is *not* GPLv3-compatible ([3], especially the second paragraph).

In addition, orthogonally, the motivation behind this licensing 
(preventing userspace code from using these plug-ins through a gross 
abuse of the anti-proprietary-plugin licensing that libgcc uses) also 
prevents them from being used with some kernel architectures that *do* 
link against libgcc.

This can all be fixed by requesting that the plug-ins be relicensed as 
"GPLv2 or later", although evidently this goes against the interests of 
the original author (PaX team) of restricting usage of these plug-ins, 
so I doubt they will do that.

Alternatively, the plug-in can be rewritten to operate on an *extracted* 
intermediate representation of the GCC internal state, with a 
GPLv3-compatible shim used as a GCC plug-in to extract said state, and 
the actual core of the transformation done in a separate binary that 
does not link with GCC and may use any license. This approach is what 
PaX team *should* have done from the beginning in order to use their 
anti-userspace licensing hack without violating any licenses, IMO. This 
would still disallow the plug-in from being used on kernel architectures 
that do link libgcc, and on userspace code that does the same.

Failing those, the only remaining option I see is a clean rewrite of the 
plug-ins without using any of the original code, and licensing that as 
GPLv2+.

[1] https://www.gnu.org/licenses/gpl-faq.en.html#GPLPlugins
[2] https://www.gnu.org/licenses/gpl-faq.en.html#GPLAndPlugins
[3] https://www.gnu.org/licenses/gpl-faq.en.html#v2v3Compatibility

-- 
Hector Martin "marcan"
Public key: https://mrcn.st/pub
