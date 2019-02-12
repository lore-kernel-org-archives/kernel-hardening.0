Subject: Re: [RFC PATCH v4 00/12] hardening: statically allocated protected
 memory
References: <cover.1549927666.git.igor.stoppa@huawei.com>
 <CAGXu5j+n3ky2dOe4F+VyneQsM4VJbGPUw+DO55NkxxPhKzKHag@mail.gmail.com>
 <25bf3c63-c54c-f7ea-bec1-996a2c05d997@gmail.com>
 <CAGXu5jLqmYRUVLb7-jPsN4onO5UNH+D6qOF=9TOiVjJa-=DnZQ@mail.gmail.com>
 <CAH2bzCRZ5xYOT0R8piqZx4mSGj1_8fNG=Ce4UU8i6F7mYD9m9Q@mail.gmail.com>
 <CAGXu5jLRJZuWjnwEuK=7AMeCrj-eioVGksPL9dE9pbzHM=+Rmg@mail.gmail.com>
From: Igor Stoppa <igor.stoppa@gmail.com>
Message-ID: <29cd9541-9af2-fc1c-c264-f4cb9c29349a@gmail.com>
Date: Tue, 12 Feb 2019 09:09:22 +0200
MIME-Version: 1.0
In-Reply-To: <CAGXu5jLRJZuWjnwEuK=7AMeCrj-eioVGksPL9dE9pbzHM=+Rmg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Kees Cook <keescook@chromium.org>
Cc: Igor Stoppa <igor.stoppa@huawei.com>, Ahmed Soliman <ahmedsoliman@mena.vt.edu>, linux-integrity <linux-integrity@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux-MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>



On 12/02/2019 03:26, Kees Cook wrote:
> On Mon, Feb 11, 2019 at 5:08 PM igor.stoppa@gmail.com
> <igor.stoppa@gmail.com> wrote:
>>
>>
>>
>> On Tue, 12 Feb 2019, 4.47 Kees Cook <keescook@chromium.org wrote:
>>>
>>> On Mon, Feb 11, 2019 at 4:37 PM Igor Stoppa <igor.stoppa@gmail.com> wrote:
>>>>
>>>>
>>>>
>>>> On 12/02/2019 02:09, Kees Cook wrote:
>>>>> On Mon, Feb 11, 2019 at 3:28 PM Igor Stoppa <igor.stoppa@gmail.com> wrote:
>>>>> It looked like only the memset() needed architecture support. Is there
>>>>> a reason for not being able to implement memset() in terms of an
>>>>> inefficient put_user() loop instead? That would eliminate the need for
>>>>> per-arch support, yes?
>>>>
>>>> So far, yes, however from previous discussion about power arch, I
>>>> understood this implementation would not be so easy to adapt.
>>>> Lacking other examples where the extra mapping could be used, I did not
>>>> want to add code without a use case.
>>>>
>>>> Probably both arm and x86 32 bit could do, but I would like to first get
>>>> to the bitter end with memory protection (the other 2 thirds).
>>>>
>>>> Mostly, I hated having just one arch and I also really wanted to have arm64.
>>>
>>> Right, I meant, if you implemented the _memset() case with put_user()
>>> in this version, you could drop the arch-specific _memset() and shrink
>>> the patch series. Then you could also enable this across all the
>>> architectures in one patch. (Would you even need the Kconfig patches,
>>> i.e. won't this "Just Work" on everything with an MMU?)
>>
>>
>> I had similar thoughts, but this answer [1] deflated my hopes (if I understood it correctly).
>> It seems that each arch needs to be massaged in separately.
> 
> True, but I think x86_64, x86, arm64, and arm will all be "normal".
> power may be that way too, but they always surprise me. :)
> 
> Anyway, series looks good, but since nothing uses _memset(), it might
> make sense to leave it out and put all the arch-enabling into a single
> patch to cover the 4 archs above, in an effort to make the series even
> smaller.

Actually, I do use it, albeit indirectly.
That's the whole point of having the IMA patch as example.

This is the fragment:
----------------
@@ -460,12 +460,13 @@ void ima_update_policy_flag(void)

  	list_for_each_entry(entry, ima_rules, list) {
  		if (entry->action & IMA_DO_MASK)
-			ima_policy_flag |= entry->action;
+			wr_assign(ima_policy_flag,
+				  ima_policy_flag | entry->action);
  	}

  	ima_appraise |= (build_ima_appraise | temp_ima_appraise);
  	if (!ima_appraise)
-		ima_policy_flag &= ~IMA_APPRAISE;
+		wr_assign(ima_policy_flag, ima_policy_flag & ~IMA_APPRAISE);
  }
----------------

wr_assign() does just that.

However, reading again your previous mails, I realize that I might have 
misinterpreted what you were suggesting.

If the advice is to have also a default memset_user() which relies on 
put_user(), but do not activate the feature by default for every 
architecture, I definitely agree that it would be good to have it.
I just didn't think about it before.

What I cannot do is to turn it on for all the architectures prior to 
test it and atm I do not have means to do it.

But I now realize that most likely you were just suggesting to have 
full, albeit inefficient default support and then let various archs 
review/enhance it. I can certainly do this.

Regarding testing I have a question: how much can/should I lean on qemu?
In most cases the MMU might not need to be fully emulated, so I wonder 
how well qemu-based testing can ensure that real life scenarios will work.

--
igor
