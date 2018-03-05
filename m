Subject: Re: [PATCH 2/7] genalloc: selftest
References: <20180228200620.30026-1-igor.stoppa@huawei.com>
 <20180228200620.30026-3-igor.stoppa@huawei.com>
From: J Freyensee <why2jjj.linux@gmail.com>
Message-ID: <488cc366-bd10-425c-ef62-ce8536e3c62a@gmail.com>
Date: Mon, 5 Mar 2018 11:37:10 -0800
MIME-Version: 1.0
In-Reply-To: <20180228200620.30026-3-igor.stoppa@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Igor Stoppa <igor.stoppa@huawei.com>, david@fromorbit.com, willy@infradead.org, keescook@chromium.org, mhocko@kernel.org
Cc: labbott@redhat.com, linux-security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


> +
> +/*
> + * In case of failure of any of these tests, memory corruption is almost
> + * guarranteed; allowing the boot to continue means risking to corrupt
> + * also any filesystem/block device accessed write mode.
> + * Therefore, BUG_ON() is used, when testing.
> + */
> +
> +

I like the explanation; good background info on why something is 
implemented the way it is :-).

Reviewed-by: Jay Freyensee <why2jjj.linux@gmail.com>
