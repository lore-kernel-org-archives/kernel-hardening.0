MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CA+KhAHbv4CbuWcKt7Sbn8g_BcMCSFaJTmHtJedDESHqHc1mmGQ@mail.gmail.com>
References: <1519899591-29761-1-git-send-email-kpark3469@gmail.com>
 <20180326143518.GA9341@arm.com> <CA+KhAHbv4CbuWcKt7Sbn8g_BcMCSFaJTmHtJedDESHqHc1mmGQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 4 Apr 2018 15:46:36 -0700
Message-ID: <CAGXu5j+D_s6qha959dCQ3ViMuXzvOwFiw=9Bsh_=wT_7maqEKQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] usercopy: reimplement arch_within_stack_frames
Content-Type: text/plain; charset="UTF-8"
To: Keun-O Park <kpark3469@gmail.com>
Cc: Will Deacon <will.deacon@arm.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, James Morse <james.morse@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, keun-o.park@darkmatter.ae
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Mar 28, 2018 at 3:16 AM, Keun-O Park <kpark3469@gmail.com> wrote:
> Hi Will,
>
> On Mon, Mar 26, 2018 at 4:35 PM, Will Deacon <will.deacon@arm.com> wrote:
>> Hi Sahara,
>>
>> On Thu, Mar 01, 2018 at 02:19:47PM +0400, kpark3469@gmail.com wrote:
>>> From: Sahara <keun-o.park@darkmatter.ae>
>>>
>>> This series of patches introduce the arm64 arch_within_stack_frames
>>> implementation using stacktrace functions. Also the base code is
>>> moved from thread_info.h to stacktrace.h. x86 code is reimplemented
>>> to use frame pointer unwinder functions.
>>
>> What's the status on this series? I'm ok taking the arm64 patch from James
>> to bring us up to speed with x86, but it doesn't make sense without the
>> first patch in the series because the arch callback is out-of-line.
>>
>> Will
>
> I haven't received any response from Kees or other engineers about
> this series of patches yet.
> Hi Kees, any comment on these patches to put these on the next stage?

Hi! Sorry for the delay, I'll send some notes now...

-Kees

-- 
Kees Cook
Pixel Security
