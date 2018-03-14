Subject: Re: [PATCH 5/8] Protectable Memory
References: <20180313214554.28521-1-igor.stoppa@huawei.com>
 <20180313214554.28521-6-igor.stoppa@huawei.com>
 <20180314121547.GE29631@bombadil.infradead.org>
 <eb9bc944-b1de-48d9-652f-9f898ec4fcec@huawei.com>
From: J Freyensee <why2jjj.linux@gmail.com>
Message-ID: <c528d92e-644b-ba2c-4494-b82cc35a26b5@gmail.com>
Date: Wed, 14 Mar 2018 10:40:34 -0700
MIME-Version: 1.0
In-Reply-To: <eb9bc944-b1de-48d9-652f-9f898ec4fcec@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
To: Igor Stoppa <igor.stoppa@huawei.com>, Matthew Wilcox <willy@infradead.org>
Cc: david@fromorbit.com, rppt@linux.vnet.ibm.com, keescook@chromium.org, mhocko@kernel.org, labbott@redhat.com, linux-security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>



>>> +struct pmalloc_data {
>>> +	struct gen_pool *pool;  /* Link back to the associated pool. */
>>> +	bool protected;     /* Status of the pool: RO or RW. */
>>> +	struct kobj_attribute attr_protected; /* Sysfs attribute. */
>>> +	struct kobj_attribute attr_avail;     /* Sysfs attribute. */
>>> +	struct kobj_attribute attr_size;      /* Sysfs attribute. */
>>> +	struct kobj_attribute attr_chunks;    /* Sysfs attribute. */
>>> +	struct kobject *pool_kobject;
>>> +	struct list_head node; /* list of pools */
>>> +};
>> sysfs attributes aren't free, you know.  I appreciate you want something
>> to help debug / analyse, but having one file for the whole subsystem or
>> at least one per pool would be a better idea.
> Which means that it should not be normal sysfs, but rather debugfs, if I
> understand correctly, since in sysfs 1 value -> 1 file.

Yes, that is a good idea, to use debugfs so you still have a means to 
debug/analyze but can be also turned off for normal system execution.  
Sorry I didn't think about that earlier to save a revision, that's one 
of my favorite things I like to use for diagnosis.

Jay
