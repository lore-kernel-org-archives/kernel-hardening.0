Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20161003215739.GO14666@pc.thejh.net>
References: <1475476886-26232-1-git-send-email-elena.reshetova@intel.com>
 <1475476886-26232-6-git-send-email-elena.reshetova@intel.com> <20161003215739.GO14666@pc.thejh.net>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 3 Oct 2016 15:21:10 -0700
Message-ID: <CAGXu5jKXcmWpryk=-yuySapqLsV_qTff3+Q1VvM38d+UsV4Gdg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [RFC PATCH 05/13] fs: identify wrapping atomic usage
To: Jann Horn <jann@thejh.net>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, David Windsor <dwindsor@gmail.com>, Hans Liljestrand <ishkamiel@gmail.com>, Elena Reshetova <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Oct 3, 2016 at 2:57 PM, Jann Horn <jann@thejh.net> wrote:
> On Mon, Oct 03, 2016 at 09:41:18AM +0300, Elena Reshetova wrote:
>> From: David Windsor <dwindsor@gmail.com>
>>
>> In some cases atomic is not used for reference
>> counting and therefore should be allowed to overflow.
>> Identify such cases and make a switch to non-hardened
>> atomic version.
>
> Depending on what the overhead ends up being, it might make sense to opt
> f_count in struct file out of the protection. It is the hottest user of
> atomic_t/atomic_long_t that I know of (incremented and decremented for
> every operation on a file descriptor in a multithreaded process), it is
> 64 bits wide and it's only incremented and decremented in steps of 1.

That's certainly an option, but I'd like to see benchmarks before we
start optimizing. :) If we can retain full coverage, that'd be
preferable.

-Kees

-- 
Kees Cook
Nexus Security
