Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1472828533-28197-1-git-send-email-catalin.marinas@arm.com>
References: <1472828533-28197-1-git-send-email-catalin.marinas@arm.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 7 Sep 2016 16:20:55 -0700
Message-ID: <CAGXu5j++0LgDEv=m1yQb4hB57MQ2MYVCpeex9TFTRmQpNYhNsQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2 0/7] arm64: Privileged Access Never using TTBR0_EL1 switching
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Julien Grall <julien.grall@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Sep 2, 2016 at 8:02 AM, Catalin Marinas <catalin.marinas@arm.com> wrote:
> This is the second version of the arm64 PAN emulation by disabling
> TTBR0_EL1 accesses. The major change from v1 is the use of a thread_info
> member to store the real TTBR0_EL1 value. The advantage is slightly
> simpler assembler macros for uaccess_enable with the downside that
> switch_mm() must always update the saved ttbr0 even if there is no mm
> switch.

Is arm64 thread_info attached to the kernel stack? (i.e. is this
introducing a valuable target for stack-based attacks?)

-Kees

-- 
Kees Cook
Nexus Security
