Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20160505210022.GA8404@grsecurity.net>
References: <1462468869-6210-1-git-send-email-michael.leibowitz@intel.com>
	<1462468869-6210-2-git-send-email-michael.leibowitz@intel.com>
	<20160505210022.GA8404@grsecurity.net>
Date: Fri, 6 May 2016 14:58:57 -0700
Message-ID: <CAB-iPKXCPY0-M2EL9GaD670+2UnvTEhk1Tdxasn=Ac6t0JBBAA@mail.gmail.com>
From: "Leibowitz, Michael" <michael.leibowitz@intel.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC 1/3] Add struct randomizing plugin
To: Brad Spengler <spender@grsecurity.net>
Cc: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, re.emese@gmail.com, pageexec@freemail.hu
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, May 5, 2016 at 2:00 PM, Brad Spengler <spender@grsecurity.net> wrote:
> Hi Michael,
>
>> + * Copyright (c) 2016, Intel Corporation.
>
> Can you please describe exactly what changes of yours to my work justify claiming
> Intel's copyright over even a sliver of the file?  What new expression of creativity
> has Intel provided here?
>
> Was it the whitespace changes?  The conversion of // to /* */ ?  The single typo fix?
> Removing the single line that breaks the plugin when used with the constify plugin?
>
> -Brad

The Intel copyright was applied as it is standard operating procedure.
After some internal discussions, we basically agree.  The changes
created here are trivial from the original and the result nearly 100%
your work.  The next RFC and any subsequent submissions will not have
the Intel copyright for trivial changes rotely applied.

Regarding the constify plugin breakage, as we don't presently have a
constify plugin, I removed it.

Cheers


-- 
Michael Leibowitz
