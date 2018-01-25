Date: Thu, 25 Jan 2018 10:38:39 -0500
From: Jerome Glisse <jglisse@redhat.com>
Message-ID: <20180125153839.GA3542@redhat.com>
References: <20180124175631.22925-1-igor.stoppa@huawei.com>
 <20180124175631.22925-5-igor.stoppa@huawei.com>
 <CAG48ez0JRU8Nmn7jLBVoy6SMMrcj46R0_R30Lcyouc4R9igi-g@mail.gmail.com>
 <6c6a3f47-fc5b-0365-4663-6908ad1fc4a7@huawei.com>
 <CAFUG7CfP_UyEH=1dmX=wsBz73+fQ0syDAy8ArKT0d4nMyf9n-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFUG7CfP_UyEH=1dmX=wsBz73+fQ0syDAy8ArKT0d4nMyf9n-g@mail.gmail.com>
Subject: Re: [kernel-hardening] [PATCH 4/6] Protectable Memory
To: Boris Lukashev <blukashev@sempervictus.com>
Cc: Igor Stoppa <igor.stoppa@huawei.com>, Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>, Michal Hocko <mhocko@kernel.org>, Laura Abbott <labbott@redhat.com>, Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <willy@infradead.org>, Christoph Lameter <cl@linux.com>, linux-security-module <linux-security-module@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, kernel list <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 25, 2018 at 10:14:28AM -0500, Boris Lukashev wrote:
> On Thu, Jan 25, 2018 at 6:59 AM, Igor Stoppa <igor.stoppa@huawei.com> wrote:

[...]

> DMA/physmap access coupled with a knowledge of which virtual mappings
> are in the physical space should be enough for an attacker to bypass
> the gating mechanism this work imposes. Not trivial, but not
> impossible. Since there's no way to prevent that sort of access in
> current hardware (especially something like a NIC or GPU working
> independently of the CPU altogether)

I am not saying this is impossible but this is unlikely they are several
mecanisms. First you have IOMMU it has been defaulted to on by OEM for
last few years (it use to be enabled only on server for virtualization).

Which means that a given device only can access memory that is mapped to
it through the IOMMU page table (usualy each device get their own distinct
IOMMU page table).

Then on device like GPU you have an MMU (no GPU without an MMU for the
last 10 years or more). The MMU is under the control of the kernel driver
of the GPU and for the open source driver we try hard to make sure it can
not be abuse and circumvent by userspace ie we restrict userspace process
to only access memory they own.

I am not saying that this can not happen but that we are trying our best
to avoid it.

Cheers,
Jérôme
