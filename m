MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1491582353.8850.169.camel@redhat.com>
References: <1491513513-84351-1-git-send-email-keescook@chromium.org>
 <1491513513-84351-17-git-send-email-keescook@chromium.org> <1491582353.8850.169.camel@redhat.com>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 7 Apr 2017 13:43:37 -0700
Message-ID: <CAGXu5jJyvDr=Vxv9Ocjtk2DF9ONAKjDhdiQGb-X-1RV9=SRWRQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [PATCH 16/18] task_struct: Allow randomized layout
To: Rik van Riel <riel@redhat.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Michael Leibowitz <michael.leibowitz@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Apr 7, 2017 at 9:25 AM, Rik van Riel <riel@redhat.com> wrote:
> On Thu, 2017-04-06 at 14:18 -0700, Kees Cook wrote:
>
>> One question about formatting remains: should this patch indent all
>> the
>> randomized fields, due to the added anonymous struct, which would
>> make
>> this patch white-space huge, or should I leave the indentation level
>> alone, to avoid massive churn? I opted for making the patch more
>> readable, but can easily do the indentation...
>
> It may make sense to do the indentation in a separate
> patch, for readability reasons.

Ah, yeah, that makes sense. I'll do three phases: the sigset_t
anonymous struct, then the non-indent-changing randomizable anon
struct, then all the whitespace...

-Kees

-- 
Kees Cook
Pixel Security
