Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 21 Sep 2016 11:31:47 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20160921103147.GD18176@leverpostej>
References: <1473947349-14521-1-git-send-email-mark.rutland@arm.com>
 <f954c330-fb58-5f8f-1d66-5bbcd0d9dadb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f954c330-fb58-5f8f-1d66-5bbcd0d9dadb@redhat.com>
Subject: [kernel-hardening] Re: [RFC PATCH 0/8] arm64: move thread_info off of the task stack
To: Laura Abbott <labbott@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org, ard.biesheuvel@linaro.org, catalin.marinas@arm.com, james.morse@arm.com, keescook@chromium.org, linux-kernel@vger.kernel.org, lorenzo.pieralisi@arm.com, luto@kernel.org, suzuki.poulose@arm.com, takahiro.akashi@linaro.org, will.deacon@arm.com, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Sep 20, 2016 at 06:26:54PM -0700, Laura Abbott wrote:
> On 09/15/2016 06:49 AM, Mark Rutland wrote:
> >Building atop of Andy's work on x86 and generic code, these patches move
> >arm64's thread_info off of the stack and into task_struct. This protects
> >thread_info from corruption in the face of stack overflow, and serves as
> >a step towards fully robust stack overflow handling will be addressed by
> >subsequent patches.
> >
> >In contrast to x86, we can't place some critical data such as
> >preempt_count in percpu variables, and we must store these in some
> >per-task location. This, compounded with the way headers are organised
> >conspires to require us to still define our own thread_info. I
> >understand that the longer term plan is to kill off thread_info
> >entirely, hence I'm sending this as an RFC so we can figure out if/how
> >we can achieve that.
> >
> >These patches are based on Andy's x86/vmap_stack branch [1,2], and I've
> >pushed a copy to me arm64/ti-stack-split branch [3,4]. The result of
> >these patches boots happily on platforms within reach of my desk, but
> >has not seen much stressing so far.
> 
> FWIW, I used your ti-stack-split branch while running some kernel builds
> and it seems to work well enough. You can take that as a Tested-by or I
> can re-test with a non-RFC version.

Thanks for testing, and many thanks for the offer!

Based on Andy's feedback some core bits are changing, and I'm hoping to
have a non-RFC version out soon once I've fixed up the remaining
fallout. I'll make sure you're Cc'd!

Thanks,
Mark.
