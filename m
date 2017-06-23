MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <45296d18-bbc3-c527-0060-b44cbff66d93@huawei.com>
References: <cf7e6840-1019-020f-ad4a-0adbe0ee79cf@huawei.com>
 <CAGXu5jK+YQoDofEJa_1Ai9anKpQ836sQ=RVOCD-Ny_pfAVmkgw@mail.gmail.com> <45296d18-bbc3-c527-0060-b44cbff66d93@huawei.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 22 Jun 2017 21:31:44 -0700
Message-ID: <CAGXu5jJPkq0OPPZD1xEN7JC5GOw=DqMygUEMmsiszni2HEtv0w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [kernel hardening]Could we do something for KSPP?
To: Li Kun <hw.likun@huawei.com>
Cc: "Wangkai (Morgan, Euler)" <morgan.wang@huawei.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jun 22, 2017 at 9:21 PM, Li Kun <hw.likun@huawei.com> wrote:
> I noticed that you have send a patch set of fast refcount overflow
> protection as below.
>
> http://kernel-hardening.openwall.narkive.com/qTKqEF4F/patch-v5-0-3-implement-fast-refcount-overflow-protection
>
> I think it is nearing accomplishment if i haven't get it wrong. Maybe i can
> do the job on arm64 based on your latest patch set?

It's certainly getting close. I'll post a v6 version for x86 soon
here, but if you want to start from v5, I think it should be
relatively easy to update it to match what gets accepted for x86.

Thanks!

-Kees

-- 
Kees Cook
Pixel Security
