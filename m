Subject: Re: [PATCH 6/7] lkdtm: crash on overwriting protected pmalloc var
From: J Freyensee <why2jjj.linux@gmail.com>
References: <20180223144807.1180-1-igor.stoppa@huawei.com>
 <20180223144807.1180-7-igor.stoppa@huawei.com>
 <1120e8fd-2f48-5b1f-7072-9bd8e2b82fbf@gmail.com>
Message-ID: <679444bd-7b41-4fb0-d7ba-98ed86da86c5@gmail.com>
Date: Tue, 6 Mar 2018 09:08:30 -0800
MIME-Version: 1.0
In-Reply-To: <1120e8fd-2f48-5b1f-7072-9bd8e2b82fbf@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
To: Igor Stoppa <igor.stoppa@huawei.com>, david@fromorbit.com, willy@infradead.org, keescook@chromium.org, mhocko@kernel.org
Cc: labbott@redhat.com, linux-security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>



On 3/6/18 9:05 AM, J Freyensee wrote:
>
>>   +#ifdef CONFIG_PROTECTABLE_MEMORY
>> +void lkdtm_WRITE_RO_PMALLOC(void)
>> +{
>> +    struct gen_pool *pool;
>> +    int *i;
>> +
>> +    pool = pmalloc_create_pool("pool", 0);
>> +    if (unlikely(!pool)) {
>> +        pr_info("Failed preparing pool for pmalloc test.");
>> +        return;
>> +    }
>> +
>> +    i = (int *)pmalloc(pool, sizeof(int), GFP_KERNEL);
>> +    if (unlikely(!i)) {
>> +        pr_info("Failed allocating memory for pmalloc test.");
>> +        pmalloc_destroy_pool(pool);
>> +        return;
>> +    }
>> +
>> +    *i = INT_MAX;
>> +    pmalloc_protect_pool(pool);
>> +
>> +    pr_info("attempting bad pmalloc write at %p\n", i);
>> +    *i = 0;
>

Opps, disregard this, this is the last series of this patch series, not 
the most recent one :-(.



> Seems harmless, but I don't get why *i local variable needs to be set 
> to 0 at the end of this function.
>
>
> Otherwise,
>
> Reviewed-by: Jay Freyensee <why2jjj.linux@gmail.com>
>
