References: <20170605192216.21596-1-igor.stoppa@huawei.com>
 <20170605192216.21596-3-igor.stoppa@huawei.com>
 <201706060444.v564iWds024768@www262.sakura.ne.jp>
 <20170606062505.GA18315@infradead.org>
 <214229a9-6e64-7351-1609-79c83d75d8c9@huawei.com>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <099c2aae-2915-5879-95da-13971d021e01@redhat.com>
Date: Tue, 6 Jun 2017 09:24:21 -0700
MIME-Version: 1.0
In-Reply-To: <214229a9-6e64-7351-1609-79c83d75d8c9@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] Re: [PATCH 2/5] Protectable Memory Allocator
To: Igor Stoppa <igor.stoppa@huawei.com>, Christoph Hellwig <hch@infradead.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: keescook@chromium.org, mhocko@kernel.org, jmorris@namei.org, paul@paul-moore.com, sds@tycho.nsa.gov, casey@schaufler-ca.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 06/06/2017 04:34 AM, Igor Stoppa wrote:
> On 06/06/17 09:25, Christoph Hellwig wrote:
>> On Tue, Jun 06, 2017 at 01:44:32PM +0900, Tetsuo Handa wrote:
> 
> [..]
> 
>>> As far as I know, not all CONFIG_MMU=y architectures provide
>>> set_memory_ro()/set_memory_rw(). You need to provide fallback for
>>> architectures which do not provide set_memory_ro()/set_memory_rw()
>>> or kernels built with CONFIG_MMU=n.
>>
>> I think we'll just need to generalize CONFIG_STRICT_MODULE_RWX and/or
>> ARCH_HAS_STRICT_MODULE_RWX so there is a symbol to key this off.
> 
> Would STRICT_KERNEL_RWX work? It's already present.
> If both kernel text and rodata can be protected, so can pmalloc data.
> 
> ---
> igor
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 


There's already ARCH_HAS_SET_MEMORY for this purpose.

Thanks,
Laura
