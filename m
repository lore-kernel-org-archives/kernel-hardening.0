Date: Tue, 25 Jul 2017 16:12:20 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170725151220.GB20857@leverpostej>
References: <1500480092-28480-1-git-send-email-mark.rutland@arm.com>
 <b28dcd14-7b4c-b4f3-830b-dbd436200df9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b28dcd14-7b4c-b4f3-830b-dbd436200df9@huawei.com>
Subject: Re: [kernel-hardening] [PATCH 00/11] ARMv8.3 pointer authentication
 userspace support
To: Li Kun <hw.likun@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org, arnd@arndb.de, catalin.marinas@arm.com, christoffer.dall@linaro.org, Dave.Martin@arm.com, jiong.wang@arm.com, kvmarm@lists.cs.columbia.edu, linux-arch@vger.kernel.org, marc.zyngier@arm.com, suzuki.poulose@arm.com, will.deacon@arm.com, yao.qi@arm.com, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jul 25, 2017 at 10:12:24PM +0800, Li Kun wrote:
> Hi Mark,

Hi,

> Could you please give us some information about the impact to
> performance to help us evaluating the influence to the system?

I'm afraid I don't have any performance details to share, as this series
has been developed and tested using models, and the performance impact
of pointer authentication will be very much dependent on the
microarchitecture.

I have assumed that this shouldn't regress performance on systems
without pointer authentication functionality, but I haven't yet
attempted to verify that.

>From this series, I'd expect the largest cost to be the semi-lazy KVM
context-switch, for guests which are continuously using pointer
authentication.

Thanks,
Mark.
