MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <2feb9661-9236-cdaf-a371-2fea80372aff@huawei.com>
References: <2feb9661-9236-cdaf-a371-2fea80372aff@huawei.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 3 Aug 2017 22:13:47 -0700
Message-ID: <CAGXu5jJwCx=LhvJGgNxD9Wu1NCTBb=yn0MQW05GSdocvqZf2Gg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening][RFD] Is there any plan to port the RAP feature
 from PAX/Grsecurity to main line ?
To: Li Kun <hw.likun@huawei.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Aug 3, 2017 at 9:23 PM, Li Kun <hw.likun@huawei.com> wrote:
> Is there any plan to port the RAP feature from PAX/Grsecurity to main line ?
> I think that will be a realy effective approach to protect against ROP/JOP.

Yeah, RAP is pretty great! I'm not aware of anyone working on
upstreaming the plugin (and its many function declaration fixes and
other adjustments) currently, though.

I've also been interested to see if kCFI[1] will be published soon,
which would be another option (it needs fewer kernel changes, but has
limitations like needing to build the kernel twice). While the code
isn't released yet, they did provide a comparison[2] to RAP which is
an interesting read.

-Kees

[1] https://github.com/kcfi/docs
[2] https://github.com/kcfi/docs/blob/master/kcfi_vs_rap.txt

-- 
Kees Cook
Pixel Security
