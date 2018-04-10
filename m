MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAJHCu1LAvw5N8cXr-L8goEXUN5+jAdC4aUv3jNW0FxO9W_VH1w@mail.gmail.com>
References: <1519729200-16056-1-git-send-email-s.mesoraca16@gmail.com>
 <CAGXu5jKYSRqsHo8rqvyR1ZLQ2MT+UnG=F4_RTEp7Sq9q9qsPtw@mail.gmail.com>
 <CAGXu5j+RELwBqkLrpQ0zHdHM3u2FxgcKokumtSS8KpkCeUgT2g@mail.gmail.com> <CAJHCu1LAvw5N8cXr-L8goEXUN5+jAdC4aUv3jNW0FxO9W_VH1w@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 10 Apr 2018 14:23:17 -0700
Message-ID: <CAGXu5jKXMx1hzQX6g=Y51mdTgHoYp4vuVUvri3=s7Fn9NgmZmA@mail.gmail.com>
Subject: Re: [PATCH v4] Protected FIFOs and regular files
Content-Type: text/plain; charset="UTF-8"
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Alexander Viro <viro@zeniv.linux.org.uk>, David Laight <David.Laight@aculab.com>, Ian Campbell <ijc@hellion.org.uk>, Jann Horn <jannh@google.com>, Matthew Wilcox <willy@infradead.org>, Pavel Vasilyev <dixlor@gmail.com>, Solar Designer <solar@openwall.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "Tobin C. Harding" <me@tobin.cc>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Feb 28, 2018 at 1:22 AM, Salvatore Mesoraca
<s.mesoraca16@gmail.com> wrote:
> 2018-02-27 21:22 GMT+01:00 Kees Cook <keescook@chromium.org>:
>> On Tue, Feb 27, 2018 at 11:47 AM, Kees Cook <keescook@chromium.org> wrote:
>>> On Tue, Feb 27, 2018 at 3:00 AM, Salvatore Mesoraca
>>> <s.mesoraca16@gmail.com> wrote:
>>>> Disallows open of FIFOs or regular files not owned by the user in world
>>>> writable sticky directories, unless the owner is the same as that of
>>>> the directory or the file is opened without the O_CREAT flag.
>>>> The purpose is to make data spoofing attacks harder.
>>>> This protection can be turned on and off separately for FIFOs and regular
>>>> files via sysctl, just like the symlinks/hardlinks protection.
>>>> This patch is based on Openwall's "HARDEN_FIFO" feature by Solar
>>>> Designer.
>>>>
>>>> This is a brief list of old vulnerabilities that could have been prevented
>>>> by this feature, some of them even allow for privilege escalation:
>>>> CVE-2000-1134
>>>> CVE-2007-3852
>>>> CVE-2008-0525
>>>> CVE-2009-0416
>>>> CVE-2011-4834
>>>> CVE-2015-1838
>>>> CVE-2015-7442
>>>> CVE-2016-7489
>>>>
>>>> This list is not meant to be complete. It's difficult to track down
>>>> all vulnerabilities of this kind because they were often reported
>>>> without any mention of this particular attack vector.
>>>> In fact, before hardlinks/symlinks restrictions, fifos/regular
>>>> files weren't the favorite vehicle to exploit them.
>>>>
>>>> Suggested-by: Solar Designer <solar@openwall.com>
>>>> Suggested-by: Kees Cook <keescook@chromium.org>
>>>> Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
>>>> [...]
>>>
>>> I think this looks great.
>>>
>>> Acked-by: Kees Cook <keescook@chromium.org>
>>
>> Tested-by: Kees Cook <keescook@chromium.org>
>
> Awesome! Thank you very much for your help!

Salvatore, do you want to send this again as a v5 with my two
follow-up patches, as I have them here:
https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/log/?h=kspp/userspace/protected-creat

or would you like me to send those? I would expect this series to land
via the -mm tree, since that tends to be the catch-all. (In which
case, the series should be To: akpm with everyone else in Cc.)

-Kees

-- 
Kees Cook
Pixel Security
