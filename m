Return-Path: <kernel-hardening-return-21950-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 6A3A4C36002
	for <kernel-hardening@archiver.kernel.org>; Thu, 20 Mar 2025 18:43:43 +0000 (UTC)
Received: (qmail 16093 invoked by uid 550); 20 Mar 2025 18:43:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9636 invoked from network); 20 Mar 2025 11:18:00 -0000
Message-ID: <7a604ae4-063f-48ff-a92f-014d1cf86adc@huawei.com>
Date: Thu, 20 Mar 2025 19:17:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 3/3] page_pool: Track DMA-mapped pages and unmap
 them when destroying the pool
To: =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>, Yunsheng
 Lin <yunshenglin0825@gmail.com>, "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Tariq
 Toukan <tariqt@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>, Eric Dumazet
	<edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Ilias Apalodimas
	<ilias.apalodimas@linaro.org>, Simon Horman <horms@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>, Mina Almasry <almasrymina@google.com>, Yonglong
 Liu <liuyonglong@huawei.com>, Pavel Begunkov <asml.silence@gmail.com>,
	Matthew Wilcox <willy@infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	IOMMU <iommu@lists.linux.dev>, <segoon@openwall.com>, <solar@openwall.com>,
	<oss-security@lists.openwall.com>, <kernel-hardening@lists.openwall.com>
CC: <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, <linux-mm@kvack.org>, Qiuling Ren
	<qren@redhat.com>, Yuying Ma <yuma@redhat.com>
References: <20250314-page-pool-track-dma-v1-0-c212e57a74c2@redhat.com>
 <20250314-page-pool-track-dma-v1-3-c212e57a74c2@redhat.com>
 <db813035-fb38-4fc3-b91e-d1416959db13@gmail.com> <87jz8nhelh.fsf@toke.dk>
 <7a76908d-5be2-43f1-a8e2-03b104165a29@huawei.com> <87wmcmhxdz.fsf@toke.dk>
 <ce6ca18b-0eda-4d62-b1d3-e101fe6dcd4e@huawei.com> <87r02ti57p.fsf@toke.dk>
Content-Language: en-US
From: Yunsheng Lin <linyunsheng@huawei.com>
In-Reply-To: <87r02ti57p.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.120.129]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemf200006.china.huawei.com (7.185.36.61)

On 2025/3/19 20:18, Toke Høiland-Jørgensen wrote:
>>
>> All I asked is about moving PP_MAGIC_MASK macro into poison.h if you
>> still want to proceed with reusing the page->pp_magic as the masking and
>> the signature to be masked seems reasonable to be in the same file.
> 
> Hmm, my thinking was that this would be a lot of irrelevant stuff to put
> into poison.h, but I suppose we could do so if the mm folks don't object :)

The masking and the signature to be masked is correlated, I am not sure
what you meant by 'irrelevant stuff' here.

As you seemed to have understood most of my concern about reusing
page->pp_magic, I am not going to argue with you about the uncertainty
of security and complexity of different address layout for different
arches again.

But I am still think it is not the way forward with the reusing of
page->pp_magic through doing some homework about the 'POISON_POINTER'.
If you still think my idea is complex and still want to proceed with
reusing the space of page->pp_magic, go ahead and let the maintainers
decide if it is worth the security risk and performance degradation.

> 
> -Toke
> 
> 
