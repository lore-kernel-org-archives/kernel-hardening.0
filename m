From: Richard Sandiford <richard.sandiford@arm.com>
Subject: Re: [PATCH 2/2] gcc-plugins: stackleak: Update for gcc-8
In-Reply-To: <d51c2fb1-3674-8df3-b0a5-65e5e3c0ad59@redhat.com> (Laura Abbott's
	message of "Mon, 26 Feb 2018 13:51:27 -0800")
References: <20180222231442.29507-1-labbott@redhat.com>
	<20180222231442.29507-3-labbott@redhat.com>
	<b579d073-7d7a-366c-77fa-08ad170e1913@linux.com>
	<d51c2fb1-3674-8df3-b0a5-65e5e3c0ad59@redhat.com>
Date: Tue, 27 Feb 2018 10:30:56 +0000
Message-ID: <87woyybu73.fsf@e105548-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain
To: Laura Abbott <labbott@redhat.com>
Cc: alex.popov@linux.com, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Will Deacon <will.deacon@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

Laura Abbott <labbott@redhat.com> writes:
> On 02/24/2018 06:04 AM, Alexander Popov wrote:
>> Hello Laura,
>> 
>> Thanks for the cooperation!
>> 
>> On 23.02.2018 02:14, Laura Abbott wrote:
>>> +#if BUILDING_GCC_VERSION >= 8000
>>> +bool check_frame_size()
>>> +{
>>> +	return maybe_ge(get_frame_size(), track_frame_size);
>> 
>> After looking through this guide
>> https://gcc.gnu.org/onlinedocs//gccint/Guidelines-for-using-poly_005fint.html#Guidelines-for-using-poly_005fint
>> it seems to me that we should better use something like that:
>> 
>> poly_int64 frame_size = get_frame_size();
>> 
>> if (frame_size.to_constant() >= track_frame_size)
>> 	return 0;
>> 
>> May I ask for your opinion?
>> 
>
> I was a bit wary of using to_constant() because I wasn't 100% sure
> I could make the assertion that it could actually be a constant so using

Yeah, the assert would fire for SVE functions that spill SVE registers
to the stack.

> maybe_ge seemed like the conservative approach. This also getting into
> compiler internals so it's possible I'm misunderstanding how poly_ints
> are supposed to work.

The maybe_ge patch looks good to me FWIW.

Thanks,
Richard
