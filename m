References: <2feb9661-9236-cdaf-a371-2fea80372aff@huawei.com>
 <CAGXu5jJwCx=LhvJGgNxD9Wu1NCTBb=yn0MQW05GSdocvqZf2Gg@mail.gmail.com>
From: Li Kun <hw.likun@huawei.com>
Message-ID: <0eb1d2c0-79ae-b2c9-4802-9104ec3db8ee@huawei.com>
Date: Fri, 4 Aug 2017 18:31:16 +0800
MIME-Version: 1.0
In-Reply-To: <CAGXu5jJwCx=LhvJGgNxD9Wu1NCTBb=yn0MQW05GSdocvqZf2Gg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
Subject: Re: [kernel-hardening][RFD] Is there any plan to port the RAP feature
 from PAX/Grsecurity to main line ?
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>



在 2017/8/4 13:13, Kees Cook 写道:
> On Thu, Aug 3, 2017 at 9:23 PM, Li Kun <hw.likun@huawei.com> wrote:
>> Is there any plan to port the RAP feature from PAX/Grsecurity to main line ?
>> I think that will be a realy effective approach to protect against ROP/JOP.
> Yeah, RAP is pretty great! I'm not aware of anyone working on
> upstreaming the plugin (and its many function declaration fixes and
> other adjustments) currently, though.
I will try to upstream it.
If i have any progress or trouble, i will show it here:)
>
> I've also been interested to see if kCFI[1] will be published soon,
> which would be another option (it needs fewer kernel changes, but has
> limitations like needing to build the kernel twice). While the code
> isn't released yet, they did provide a comparison[2] to RAP which is
> an interesting read.
That looks awsome. Does it have any schedule to release the code?
>
> -Kees
>
> [1] https://github.com/kcfi/docs
> [2] https://github.com/kcfi/docs/blob/master/kcfi_vs_rap.txt
>

-- 
Best Regards
Li Kun
