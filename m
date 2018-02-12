Subject: Re: [PATCH 4/6] Protectable Memory
References: <20180211031920.3424-1-igor.stoppa@huawei.com>
 <20180211031920.3424-5-igor.stoppa@huawei.com>
 <20180211123743.GC13931@rapoport-lnx>
 <e7ea02b4-3d43-9543-3d14-61c27e155042@huawei.com>
 <20180212114310.GD20737@rapoport-lnx> <20180212125347.GE20737@rapoport-lnx>
 <68edadf0-2b23-eaeb-17de-884032f0b906@huawei.com>
 <20180212153156.GF20737@rapoport-lnx>
From: Igor Stoppa <igor.stoppa@huawei.com>
Message-ID: <f5c08b12-a274-f2db-5cf2-8b774489c425@huawei.com>
Date: Mon, 12 Feb 2018 17:41:52 +0200
MIME-Version: 1.0
In-Reply-To: <20180212153156.GF20737@rapoport-lnx>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: willy@infradead.org, rdunlap@infradead.org, corbet@lwn.net, keescook@chromium.org, mhocko@kernel.org, labbott@redhat.com, jglisse@redhat.com, hch@infradead.org, cl@linux.com, linux-security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 12/02/18 17:31, Mike Rapoport wrote:

[...]

> Seems that kernel-doc does not consider () as a valid match for the
> identifier :)
>  
> Can you please check with the below patch?

yes, it works now, than you!

--
igor
