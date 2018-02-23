Subject: Re: [PATCH 2/7] genalloc: selftest
References: <20180223144807.1180-1-igor.stoppa@huawei.com>
 <20180223144807.1180-3-igor.stoppa@huawei.com>
From: J Freyensee <why2jjj.linux@gmail.com>
Message-ID: <76b3d858-b14e-b66d-d8ae-dbd0b307308a@gmail.com>
Date: Fri, 23 Feb 2018 14:42:57 -0800
MIME-Version: 1.0
In-Reply-To: <20180223144807.1180-3-igor.stoppa@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Igor Stoppa <igor.stoppa@huawei.com>, david@fromorbit.com, willy@infradead.org, keescook@chromium.org, mhocko@kernel.org
Cc: labbott@redhat.com, linux-security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


> +	locations[action->location] = gen_pool_alloc(pool, action->size);
> +	BUG_ON(!locations[action->location]);

Again, I'd think it through if you really want to use BUG_ON() or not:

https://lwn.net/Articles/13183/
https://lkml.org/lkml/2016/10/4/1

Thanks,
Jay
