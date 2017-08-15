Date: Tue, 15 Aug 2017 15:00:35 +0100
From: Will Deacon <will.deacon@arm.com>
Message-ID: <20170815140035.GA18351@arm.com>
References: <1502801449-29246-1-git-send-email-mark.rutland@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1502801449-29246-1-git-send-email-mark.rutland@arm.com>
Subject: [kernel-hardening] Re: [PATCHv2 00/14] arm64: VMAP_STACK support
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, ard.biesheuvel@linaro.org, catalin.marinas@arm.com, james.morse@arm.com, labbott@redhat.com, linux-kernel@vger.kernel.org, luto@amacapital.net, matt@codeblueprint.co.uk, kernel-hardening@lists.openwall.com, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Aug 15, 2017 at 01:50:35PM +0100, Mark Rutland wrote:
> Ard and I have worked together to implement vmap stack support for
> arm64. This supersedes our earlier vmap stack RFCs [0,1]. The git author
> stats are a little misleading, as I've teased parts out into smaller
> patches for review.
> 
> The series is based on our stack dump rework [2,3], which can be found
> in the arm64/exception-stack branch [4] of my kernel.org repo. This
> series can be found in the arm64/vmap-stack branch [5] of the same repo.
> 
> Since v1 [6]:
> * Fix typos
> * Update comments in entry assembly
> * Dump exception context (and stacks) before regs
> * Define safe adr_this_cpu for modules

Thanks:

Reviewed-by: Will Deacon <will.deacon@arm.com>

for the series.

Will
