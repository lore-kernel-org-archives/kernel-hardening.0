Subject: Re: Correct way to access the physmap? - Was: Re: [PATCH 7/9] Pmalloc
 Rare Write: modify selected pools
References: <20180423125458.5338-1-igor.stoppa@huawei.com>
 <20180423125458.5338-8-igor.stoppa@huawei.com>
 <20180424115050.GD26636@bombadil.infradead.org>
 <035f2bba-ebb1-06a0-fb88-3d40f7e484a7@gmail.com>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <ef116557-1fb1-780e-2480-3eef9052b609@intel.com>
Date: Thu, 3 May 2018 14:55:23 -0700
MIME-Version: 1.0
In-Reply-To: <035f2bba-ebb1-06a0-fb88-3d40f7e484a7@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Igor Stoppa <igor.stoppa@gmail.com>, Matthew Wilcox <willy@infradead.org>
Cc: linux-security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Igor Stoppa <igor.stoppa@huawei.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 05/03/2018 02:52 PM, Igor Stoppa wrote:
> At the end of the summit, we agreed that I would go through the physmap.

Do you mean the kernel linear map?  That's just another name for the
virtual address that you get back from page_to_virt():

	int *j = page_to_virt(vmalloc_to_page(i));
