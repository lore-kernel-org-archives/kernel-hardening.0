Subject: Re: [PATCH 6/7] lkdtm: crash on overwriting protected pmalloc var
References: <20180228200620.30026-1-igor.stoppa@huawei.com>
 <20180228200620.30026-7-igor.stoppa@huawei.com>
 <1723ee8d-c89e-0704-c2c3-254eda39dc8b@gmail.com>
 <6378e63e-174f-642e-d319-1d121b74d3d7@huawei.com>
From: J Freyensee <why2jjj.linux@gmail.com>
Message-ID: <2664691b-4d48-1701-8dae-774ec7733f61@gmail.com>
Date: Wed, 7 Mar 2018 09:26:55 -0800
MIME-Version: 1.0
In-Reply-To: <6378e63e-174f-642e-d319-1d121b74d3d7@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Igor Stoppa <igor.stoppa@huawei.com>, david@fromorbit.com, willy@infradead.org, keescook@chromium.org, mhocko@kernel.org
Cc: labbott@redhat.com, linux-security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>



On 3/7/18 5:18 AM, Igor Stoppa wrote:
>
> On 06/03/18 19:20, J Freyensee wrote:
>
>> On 2/28/18 12:06 PM, Igor Stoppa wrote:
> [...]
>
>>>    void __init lkdtm_perms_init(void);
>>>    void lkdtm_WRITE_RO(void);
>>>    void lkdtm_WRITE_RO_AFTER_INIT(void);
>>> +void lkdtm_WRITE_RO_PMALLOC(void);
>> Does this need some sort of #ifdef too?
> Not strictly. It's just a function declaration.
> As long as it is not used, the linker will not complain.
> The #ifdef placed around the use and definition is sufficient, from a
> correctness perspective.
>
> But it's a different question if there is any standard in linux about
> hiding also the declaration.


I'd prefer hiding it if it's contents are being ifdef'ed out, but I 
really think it's more of a maintainer preference question.


>
> I am not very fond of #ifdefs, so when I can I try to avoid them.
>
>
