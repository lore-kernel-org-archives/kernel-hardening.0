Subject: Re: [PATCH 6/7] lkdtm: crash on overwriting protected pmalloc var
References: <20180228200620.30026-1-igor.stoppa@huawei.com>
 <20180228200620.30026-7-igor.stoppa@huawei.com>
 <1723ee8d-c89e-0704-c2c3-254eda39dc8b@gmail.com>
From: Igor Stoppa <igor.stoppa@huawei.com>
Message-ID: <6378e63e-174f-642e-d319-1d121b74d3d7@huawei.com>
Date: Wed, 7 Mar 2018 15:18:16 +0200
MIME-Version: 1.0
In-Reply-To: <1723ee8d-c89e-0704-c2c3-254eda39dc8b@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: J Freyensee <why2jjj.linux@gmail.com>, david@fromorbit.com, willy@infradead.org, keescook@chromium.org, mhocko@kernel.org
Cc: labbott@redhat.com, linux-security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>



On 06/03/18 19:20, J Freyensee wrote:

> On 2/28/18 12:06 PM, Igor Stoppa wrote:

[...]

>>   void __init lkdtm_perms_init(void);
>>   void lkdtm_WRITE_RO(void);
>>   void lkdtm_WRITE_RO_AFTER_INIT(void);
>> +void lkdtm_WRITE_RO_PMALLOC(void);
> 
> Does this need some sort of #ifdef too?

Not strictly. It's just a function declaration.
As long as it is not used, the linker will not complain.
The #ifdef placed around the use and definition is sufficient, from a
correctness perspective.

But it's a different question if there is any standard in linux about
hiding also the declaration.

I am not very fond of #ifdefs, so when I can I try to avoid them.

>> +	pr_info("attempting bad pmalloc write at %p\n", i);
>> +	*i = 0;
> 
> OK, now I'm on the right version of this patch series, same comment 
> applies.  I don't get the local *i assignment at the end of the 
> function, but seems harmless.


Because that's the whole point of the function: prove that pmalloc
protection works (see the message in the pr_info one line above).

The function is supposed to do:

* create a pool
* allocate memory from it
* protect it
* try to alter it (and crash)

*i = 0; performs the last step

--
igor
