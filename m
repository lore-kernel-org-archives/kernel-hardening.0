MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1493906699.29205.1.camel@redhat.com>
References: <20170504133209.3053-1-danielmicay@gmail.com> <1493906699.29205.1.camel@redhat.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 4 May 2017 07:29:36 -0700
Message-ID: <CAGXu5jJ99oYmC9hGdtnmdrB3w3ovp=3y2Qfh95z9oDia7JO6KA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [PATCH] use get_random_long for the per-task
 stack canary
To: Daniel Micay <danielmicay@gmail.com>, Ingo Molnar <mingo@elte.hu>
Cc: Rik van Riel <riel@redhat.com>, Arjan van Ven <arjan@linux.intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, May 4, 2017 at 7:04 AM, Rik van Riel <riel@redhat.com> wrote:
> On Thu, 2017-05-04 at 09:32 -0400, Daniel Micay wrote:
>> The stack canary is an unsigned long and should be fully initialized
>> to
>> random data rather than only 32 bits of random data.
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Daniel Micay <danielmicay@gmail.com>
>>
> Acked-by: Rik van Riel <riel@redhat.com>

Thanks! Ingo, should this go via tip?

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
Pixel Security
