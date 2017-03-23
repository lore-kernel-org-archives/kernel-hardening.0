MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170323074001.GB14258@gmail.com>
References: <1489160052-20293-1-git-send-email-dwindsor@gmail.com>
 <CAGXu5jJuzpSeosAQxkewWB3804+pUrJ9HiU3p-8SOo2hTwFwbQ@mail.gmail.com> <20170323074001.GB14258@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 23 Mar 2017 07:06:55 -0700
Message-ID: <CAGXu5jLfDdq1E0vXda4tqrHSqSGhk76Biemh6axaycOB+E-zfQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3] refcount: add refcount_t API kernel-doc comments
To: Ingo Molnar <mingo@kernel.org>
Cc: David Windsor <dwindsor@gmail.com>, Peter Zijlstra <peterz@infradead.org>, "Reshetova, Elena" <elena.reshetova@intel.com>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 23, 2017 at 12:40 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Kees Cook <keescook@chromium.org> wrote:
>
>> On Fri, Mar 10, 2017 at 7:34 AM, David Windsor <dwindsor@gmail.com> wrote:
>> > v3: rebase against latest Linus tree; re-add include/linux/refcount.h
>> > missing from v2 series
>> >
>> > Signed-off-by: David Windsor <dwindsor@gmail.com>
>>
>> Reviewed-by: Kees Cook <keescook@chromium.org>
>>
>> Ingo, can you pull this into tip? I like having more documentation here. :)
>
> So I hopped into my time machine and applied it to tip:locking/core as of March
> 13th:
>
>   commit bd174169c7a12a37b3b4aa2221f084ade010b182
>   Author:     David Windsor <dwindsor@gmail.com>
>   AuthorDate: Fri Mar 10 10:34:12 2017 -0500
>   Commit:     Ingo Molnar <mingo@kernel.org>
>   CommitDate: Mon Mar 13 07:41:08 2017 +0100
>
> You are welcome! ;-)

I love time-travelling maintainers! They are very tolerant of people
who don't double-check -next first. :)

Thanks!

-Kees

-- 
Kees Cook
Pixel Security
