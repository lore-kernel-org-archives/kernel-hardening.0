MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <dc146cb5-98fc-57f9-e4c8-3e1bd6d78acf@marcan.st>
References: <1497018608-22168-1-git-send-email-alex.popov@linux.com> <dc146cb5-98fc-57f9-e4c8-3e1bd6d78acf@marcan.st>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 20 Jun 2017 12:07:25 -0700
Message-ID: <CAGXu5j++EC_HSjrHJ1=ax=8WMooNpd3o2U=+csUp2mgWyunsmQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [PATCH RFC v2 1/1] gcc-plugins: Add stackleak
 feature erasing the kernel stack at the end of syscalls
To: Hector Martin marcan <marcan@marcan.st>
Cc: Alexander Popov <alex.popov@linux.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Tycho Andersen <tycho@docker.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 20, 2017 at 2:06 AM, Hector Martin "marcan"
<marcan@marcan.st> wrote:
> On 09/06/17 23:30, Alexander Popov wrote:
>>
>> +/*
>> + * Copyright 2011-2017 by the PaX Team <pageexec@freemail.hu>
>> + * Licensed under the GPL v2
>> + *
>> + * Note: the choice of the license means that the compilation process is
>> + *       NOT 'eligible' as defined by gcc's library exception to the GPL
>> v3,
>> + *       but for the kernel it doesn't matter since it doesn't link
>> against
>> + *       any of the gcc libraries
>
>
> I know this isn't the first time I've mentioned this, but I think it bears
> repeating that, as far as I understand the licensing (IANAL), GCC plug-ins
> licensed as GPLv2 are in violation of the GCC license.

I continue to think that the wording is unclear and that rational
people can come to different conclusions. To guide me I try to look at
the intent of the license ("stay Free Software") and the decisions of
the author ("this should be GPLv2"). Since the authors are quite clear
about their rationale, and I don't see anything that appears to be
trying to dodge the plugin being Free Software, I stand by my earlier
conclusion[1].

-Kees

[1] http://www.openwall.com/lists/kernel-hardening/2016/05/31/1

-- 
Kees Cook
Pixel Security
