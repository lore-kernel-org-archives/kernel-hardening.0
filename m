MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <44d0ad13-6362-6224-ae64-d1848d217f0b@linux.com>
References: <1499724283-30719-1-git-send-email-labbott@redhat.com>
 <1499724283-30719-3-git-send-email-labbott@redhat.com> <20170711195154.GA7124@leverpostej>
 <2f24df9e-64b1-ffef-ddbb-08f7fe8d2a96@redhat.com> <f100d5f3-fabc-a6b4-ef5f-91fc5f123299@linux.com>
 <160e3088-b8e0-513b-8c1a-ce22ce598d5a@redhat.com> <44d0ad13-6362-6224-ae64-d1848d217f0b@linux.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 24 Jul 2017 20:34:31 -0700
Message-ID: <CAGXu5jKp0J_6+upysRXbc1Khjzr20DrdM6As8ZS=QcccN7jpfg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [RFC][PATCH 2/2] arm64: Clear the stack
To: Alexander Popov <alex.popov@linux.com>
Cc: Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Tycho Andersen <tycho@docker.com>, PaX Team <pageexec@freemail.hu>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jul 24, 2017 at 1:19 AM, Alexander Popov <alex.popov@linux.com> wrote:
> On 22.07.2017 03:23, Laura Abbott wrote:
>> On 07/21/2017 09:56 AM, Alexander Popov wrote:
>>> So let's keep it not to break CONFIG_SCHED_STACK_END_CHECK.
>>
>> That makes sense, good find! I wonder if CONFIG_SCHED_STACK_END_CHECK
>> should go on the list of hardening options and/or if we can enhance
>> it somehow?
>
> Do you mean this list?
> http://www.kernsec.org/wiki/index.php/Kernel_Self_Protection_Project/Recommended_Settings
>
>> I'm not sure why it requires two words though since the
>> poison only seems to be 32-bits?
>
> On x86_64 end_of_stack() returns the pointer to unsigned long, so we need at
> least 8 bytes to avoid breaking CONFIG_SCHED_STACK_END_CHECK. Don't know about 8
> more bytes.

Seems like this should be a random value like the per-frame stack
canary, but it looks like a relatively cheap check. It's probably not
in the cache, though, since most stack operations should be pretty far
from the end of the stack...

-Kees

-- 
Kees Cook
Pixel Security
