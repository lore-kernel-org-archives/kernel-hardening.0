Reply-To: kernel-hardening@lists.openwall.com
References: <20170118135310.GA4733@pjb1027-Latitude-E5410>
 <e5433e24-7a3d-25a4-26a3-9d02644cc3f4@redhat.com>
 <20170118223629.GQ27312@n2100.armlinux.org.uk>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <46bae2bb-4b4f-158b-6a8d-3737e181ad74@redhat.com>
Date: Wed, 18 Jan 2017 15:38:52 -0800
MIME-Version: 1.0
In-Reply-To: <20170118223629.GQ27312@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Subject: Re: [kernel-hardening] Re: [PATCH] ARM: mm: add testcases for RODATA
To: kernel-hardening@lists.openwall.com
Cc: Jinbum Park <jinb.park7@gmail.com>, mark.rutland@arm.com, f.fainelli@gmail.com, keescook@chromium.org, pawel.moll@arm.com, ard.biesheuvel@linaro.org, kernel-janitors@vger.kernel.org, will.deacon@arm.com, linux-kernel@vger.kernel.org, paul.gortmaker@windriver.com, vladimir.murzin@arm.com, andy.gross@linaro.org, arjan@linux.intel.com, mingo@kernel.org, linux-arm-kernel@lists.infradead.org, jonathan.austin@arm.com
List-ID: <kernel-hardening.lists.openwall.com>

On 01/18/2017 02:36 PM, Russell King - ARM Linux wrote:
> On Wed, Jan 18, 2017 at 11:20:54AM -0800, Laura Abbott wrote:
>> On 01/18/2017 05:53 AM, Jinbum Park wrote:
>>> diff --git a/arch/arm/include/asm/cacheflush.h b/arch/arm/include/asm/cacheflush.h
>>> index bdd283b..741e2e8 100644
>>> --- a/arch/arm/include/asm/cacheflush.h
>>> +++ b/arch/arm/include/asm/cacheflush.h
>>> @@ -498,6 +498,16 @@ static inline void set_kernel_text_rw(void) { }
>>>  static inline void set_kernel_text_ro(void) { }
>>>  #endif
>>>  
>>> +#ifdef CONFIG_DEBUG_RODATA_TEST
>>> +extern const int rodata_test_data;
>>> +int rodata_test(void);
>>> +#else
>>> +static inline int rodata_test(void)
>>> +{
>>> +	return 0;
>>> +}
>>> +#endif
>>> +
> 
> I don't see why this needs to be in cacheflush.h - it doesn't seem to
> have anything to do with cache flushing, and placing it in here means
> that if you change the state of CONFIG_DEBUG_RODATA_TEST, most likely
> the entire kernel gets rebuilt.  Please put it in a separate header
> file.
> 

cacheflush.h seems to be where all the set_memory_* functions have
ended up. I was just looking at cleaning that up unless someone
beats me to it.

Thanks,
Laura
