References: <1499724283-30719-1-git-send-email-labbott@redhat.com>
 <1499724283-30719-3-git-send-email-labbott@redhat.com>
 <20170711195154.GA7124@leverpostej>
 <2f24df9e-64b1-ffef-ddbb-08f7fe8d2a96@redhat.com>
 <f100d5f3-fabc-a6b4-ef5f-91fc5f123299@linux.com>
 <160e3088-b8e0-513b-8c1a-ce22ce598d5a@redhat.com>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <44d0ad13-6362-6224-ae64-d1848d217f0b@linux.com>
Date: Mon, 24 Jul 2017 11:19:26 +0300
MIME-Version: 1.0
In-Reply-To: <160e3088-b8e0-513b-8c1a-ce22ce598d5a@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [RFC][PATCH 2/2] arm64: Clear the stack
To: Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>
Cc: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Tycho Andersen <tycho@docker.com>, PaX Team <pageexec@freemail.hu>
List-ID: <kernel-hardening.lists.openwall.com>

On 22.07.2017 03:23, Laura Abbott wrote:
> On 07/21/2017 09:56 AM, Alexander Popov wrote:
>> So let's keep it not to break CONFIG_SCHED_STACK_END_CHECK.
> 
> That makes sense, good find! I wonder if CONFIG_SCHED_STACK_END_CHECK
> should go on the list of hardening options and/or if we can enhance
> it somehow?

Do you mean this list?
http://www.kernsec.org/wiki/index.php/Kernel_Self_Protection_Project/Recommended_Settings

> I'm not sure why it requires two words though since the
> poison only seems to be 32-bits?

On x86_64 end_of_stack() returns the pointer to unsigned long, so we need at
least 8 bytes to avoid breaking CONFIG_SCHED_STACK_END_CHECK. Don't know about 8
more bytes.

Best regards,
Alexander
