MIME-Version: 1.0
In-Reply-To: <20171122132235.GA30635@bombadil.infradead.org>
References: <1511337706-8297-1-git-send-email-s.mesoraca16@gmail.com>
 <1511337706-8297-3-git-send-email-s.mesoraca16@gmail.com> <20171122132235.GA30635@bombadil.infradead.org>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Fri, 24 Nov 2017 09:29:22 +0100
Message-ID: <CAJHCu1KT2zQnoUN3x+yrZ7X9MH+hSCknOu-KV=8-Jdo3Km7z-Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v3 2/2] Protected O_CREAT open in sticky directories
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-kernel@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>, "Eric W. Biederman" <ebiederm@xmission.com>
List-ID: <kernel-hardening.lists.openwall.com>

2017-11-22 14:22 GMT+01:00 Matthew Wilcox <willy@infradead.org>:
> On Wed, Nov 22, 2017 at 09:01:46AM +0100, Salvatore Mesoraca wrote:
>> +An O_CREAT open missing the O_EXCL flag in a sticky directory is,
>> +often, a bug or a synthom of the fact that the program is not
>> +using appropriate procedures to access sticky directories.
>> +This protection allow to detect and possibly block these unsafe
>> +open invocations, even if the files don't exist yet.
>> +Though should be noted that, sometimes, it's OK to open a file
>> +with O_CREAT and without O_EXCL (e.g. shared lock files based
>> +on flock()), for this reason values above 2 should be set
>> +with care.
>> +
>> +When set to "0" the protection is disabled.
>> +
>> +When set to "1", notify about O_CREAT open missing the O_EXCL flag
>> +in world writable sticky directories.
>> +
>> +When set to "2", notify about O_CREAT open missing the O_EXCL flag
>> +in world or group writable sticky directories.
>> +
>> +When set to "3", block O_CREAT open missing the O_EXCL flag
>> +in world writable sticky directories and notify (but don't block)
>> +in group writable sticky directories.
>> +
>> +When set to "4", block O_CREAT open missing the O_EXCL flag
>> +in world writable and group writable sticky directories.
>
> This seems insufficiently flexible.  For example, there is no way for me
> to specify that I want to block O_CREAT without O_EXCL in world-writable,
> but not be notified about O_CREAT without O_EXCL in group-writable.

I understand your concern, I did it like this because I wanted to keep the
interface as simple as possible. But, maybe, more flexibility it's better.

> And maybe I want to be notified that blocking has happened?

I didn't write it explicitly in the doc, but you will always be notified
that blocking has happened. On the other hand you don't have any way to
suppress those notification.

> Why not make it bits?  So:
>
> 0 => notify in world
> 1 => block in world
> 2 => notify in group
> 3 => block in group
>
> So you'd have the following meaningful values:
>
>  0 - permit all (your option 0)
>  1 - notify world; permit group (your option 1)
>  2 - block world; permit group
>  3 - block,notify world; permit group
>  4 - permit world; notify group (?)
>  5 - notify world; notify group (your option 2)
>  6 - block world; notify group (your option 3)
>  7 - block,notify world; notify group
>  8 - permit world; block group (?)
>  9 - notify world; block group (?)
> 10 - block world; block group (your option 4)
> 11 - block,notify world; block group
> 12 - permit world; block, notify group (?)
> 13 - notify world; block, notify group (?)
> 14 - block world; block, notify group
> 15 - block, notify world; block, notify group
>
> Some of these don't make a lot of sense (marked with ?), but I don't see
> the harm in permitting a sysadmin to do something that seems nonsensical
> to me.

I like your idea of using "bits" this way, even if it will allow sysadmins
to set values that don't make too much sense.
Thank you very much for your suggestions,

Salvatore
