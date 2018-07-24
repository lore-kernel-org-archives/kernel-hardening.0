Date: Tue, 24 Jul 2018 17:38:08 +0100
From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCHv3 0/2] Stackleak for arm64
Message-ID: <20180724163807.GE25888@arm.com>
References: <1531341400-12077-1-git-send-email-alex.popov@linux.com>
 <20180720214154.2940-1-labbott@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180720214154.2940-1-labbott@redhat.com>
To: Laura Abbott <labbott@redhat.com>
Cc: Alexander Popov <alex.popov@linux.com>, Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Laura,

On Fri, Jul 20, 2018 at 02:41:52PM -0700, Laura Abbott wrote:
> This is the version of stackleak for arm64, hopefully ready for queueing

Thanks. I'll push these into linux-next tomorrow, once I've had a chance
to test my conflict resolution in entry.S.

Will
