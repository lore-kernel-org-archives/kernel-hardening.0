MIME-Version: 1.0
In-Reply-To: <03284709-498c-1e52-40f0-b19d20e56b8e@linux.vnet.ibm.com>
References: <1490730347-5165-1-git-send-email-bhsharma@redhat.com>
 <87shlcq0es.fsf@skywalker.in.ibm.com> <CACi5LpP5jC7obg57zj2jZUQCoh_Et2rbdQMtthXy3Ksb2Qc4ow@mail.gmail.com>
 <03284709-498c-1e52-40f0-b19d20e56b8e@linux.vnet.ibm.com>
From: Balbir Singh <bsingharora@gmail.com>
Date: Thu, 13 Apr 2017 17:09:10 +1000
Message-ID: <CAKTCnzmin1TgTd5w6es=bekLF+pSjBgVU9ch+Z9r=_voD6U5Zw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3] powerpc: mm: support ARCH_MMAP_RND_BITS
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Bhupesh Sharma <bhsharma@redhat.com>, Bhupesh SHARMA <bhupesh.linux@gmail.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Alistair Popple <alistair@popple.id.au>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Scott Wood <oss@buserror.net>, Paul Mackerras <paulus@samba.org>, Alexander Graf <agraf@suse.com>, Daniel Cashman <dcashman@android.com>, Anatolij Gustschin <agust@denx.de>, "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" <linuxppc-dev@lists.ozlabs.org>, Daniel Cashman <dcashman@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

>>
>> Yes. It was derived from TASK_SIZE :
>>
>> http://lxr.free-electrons.com/source/arch/powerpc/include/asm/processor.h#L105
>>
>
> That is getting update to 128TB by default and conditionally to 512TB
>

Since this is compile time, we should probably keep the scope to 128TB
for now and see if we want to change things at run time later, since
the expansion is based on a hint. Suggestions?

Balbir
