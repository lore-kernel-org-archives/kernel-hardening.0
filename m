MIME-Version: 1.0
In-Reply-To: <CAGXu5jKVsT19LuN4qbs-x2oJjV=A7Z65p9K-4-PzMxPRrPWngg@mail.gmail.com>
References: <1486511794-14490-1-git-send-email-dwindsor@gmail.com> <CAGXu5jKVsT19LuN4qbs-x2oJjV=A7Z65p9K-4-PzMxPRrPWngg@mail.gmail.com>
From: David Windsor <dwindsor@gmail.com>
Date: Fri, 10 Feb 2017 09:44:04 -0500
Message-ID: <CAEXv5_jma18vzjjkW4DXV852BXXu9hipDXi4B3yYaB=684ox0w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] refcount: add refcount_t API kernel-doc comments
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Peter Zijlstra <peterz@infradead.org>, "Reshetova, Elena" <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 7, 2017 at 7:49 PM, Kees Cook <keescook@chromium.org> wrote:
> On Tue, Feb 7, 2017 at 3:56 PM, David Windsor <dwindsor@gmail.com> wrote:
>> This adds kernel-doc comments for the new refcount_t API.  Additional feature documentation can go in
>> Documentation/security, if needed.
>
> Very cool. This may need to get rebased to Peter's lastest series
> (which uses REFCOUNT_WARN rather than WARN).
>
> Please add a "Signed-off-by:" line as well.
>
> I think it'd also be valuable to have some documentation describing
> how to actually use these, similar to your Examples section on the
> wiki.
>

I just submitted v2 of this documentation patchset, which adds
refcount_t API kernel-doc comments to include/linux/refcount.h.

I'll add some language to Documentation/security/self-protection.txt,
documenting the feature's justification, typical usage examples, etc.
This location was decided upon in an earlier discussion on this
mailing list.

Thanks,
David

> -Kees
>
> --
> Kees Cook
> Pixel Security
