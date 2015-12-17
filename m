Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20151217181143.GA18680@kroah.com>
References: <1450364270-12687-1-git-send-email-dave@progbits.org>
	<1450364270-12687-2-git-send-email-dave@progbits.org>
	<20151217171645.GA7495@kroah.com>
	<CAEXv5_j8Bo9u1WUTH2QwYwye+j9270S+rgzjnsvcbojrYW7sfQ@mail.gmail.com>
	<20151217181143.GA18680@kroah.com>
Date: Thu, 17 Dec 2015 13:23:15 -0500
Message-ID: <CAEXv5_h9nhKcd3_NYYnofOjorovm4NLbLuZoWzAbZKhM5uiEcg@mail.gmail.com>
From: David Windsor <dave@progbits.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening][RFC PATCH v2 01/12] x86: add PAX_REFCOUNT support
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Well, pax_report_refcount_overflow is the mechanism for logging
overflows and for killing the offending process.  Since that's related
to adding PAX_REFCOUNT protection (not necessarily to just x86,
though), I put it in this patch.  I suppose I could have made another
patch for arch-independent changes like this.

You are correct that CONFIG_GRKERNSEC and CONFIG_PAX_REFCOUNT aren't
currently in the kernel, but they are both added in a later patch in
this series (patch 11/12).  I should have made those changes part of
this patch, though.  I will update the series and resubmit later.

Hopefully this answers your question?

Thanks,
David

On Thu, Dec 17, 2015 at 1:11 PM, Greg KH <greg@kroah.com> wrote:
> On Thu, Dec 17, 2015 at 12:55:44PM -0500, David Windsor wrote:
>> On Thu, Dec 17, 2015 at 12:16 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> > On Thu, Dec 17, 2015 at 09:57:39AM -0500, David Windsor wrote:
>> >> --- a/include/linux/sched.h
>> >> +++ b/include/linux/sched.h
>> >> @@ -749,6 +749,17 @@ struct signal_struct {
>> >>  #ifdef CONFIG_TASKSTATS
>> >>       struct taskstats *stats;
>> >>  #endif
>> >> +
>> >> +#ifdef CONFIG_GRKERNSEC
>> >> +     u32 curr_ip;
>> >> +     u32 saved_ip;
>> >> +     u32 gr_saddr;
>> >> +     u32 gr_daddr;
>> >> +     u16 gr_sport;
>> >> +     u16 gr_dport;
>> >> +     u8 used_accept:1;
>> >> +#endif
>> >> +
>> >
>> > Why is this here in this patch?
>> >
>>
>> For pax_report_refcount_overflow in fs/exec.c:
>>
>> 1754: if (current->signal->curr_ip)
>>
>> This is guarded by CONFIG_PAX_REFCOUNT, which, as it stands, should
>> depend on CONFIG_GRKERNSEC.  The Kconfig options likely need to
>> change, depending on the naming of these features moving forward.
>
> But that has nothing to do with this patch, and as that config option
> isn't present in the kernel at this point in time, this change is not
> needed at all, right?
>
> Or am I missing something?
>
> thanks,
>
> greg k-h
