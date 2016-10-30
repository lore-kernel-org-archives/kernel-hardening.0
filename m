Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 30 Oct 2016 15:03:07 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
Message-ID: <20161030150307.33vc2m7y5y6wzbqc@localhost>
References: <1477585654-8908-1-git-send-email-labbott@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1477585654-8908-1-git-send-email-labbott@redhat.com>
Subject: [kernel-hardening] Re: [PATCHv4 0/4] WX checking for arm64
To: Laura Abbott <labbott@redhat.com>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, David Brown <david.brown@linaro.org>, Will Deacon <will.deacon@arm.com>, linux-efi@vger.kernel.org, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Matt Fleming <matt@codeblueprint.co.uk>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Oct 27, 2016 at 09:27:30AM -0700, Laura Abbott wrote:
> Laura Abbott (4):
>   arm64: dump: Make ptdump debugfs a separate option
>   arm64: dump: Make the page table dumping seq_file optional
>   arm64: dump: Remove max_addr
>   arm64: dump: Add checking for writable and exectuable pages

Queued for 4.10. Thanks.

-- 
Catalin
