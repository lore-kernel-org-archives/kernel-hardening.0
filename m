Reply-To: kernel-hardening@lists.openwall.com
References: <20160308002035.GA13606@www.outflux.net>
 <CAGXu5jLu5NFw=7xoJEYcAq7MFwGY1nuB8w-q+NVp2d2zpwRUyQ@mail.gmail.com>
From: Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <56DE9279.6040805@de.ibm.com>
Date: Tue, 8 Mar 2016 09:51:05 +0100
MIME-Version: 1.0
In-Reply-To: <CAGXu5jLu5NFw=7xoJEYcAq7MFwGY1nuB8w-q+NVp2d2zpwRUyQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [RFC][PATCH] s390, postinit-readonly: implement post-init RO
To: Kees Cook <keescook@chromium.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Ingo Molnar <mingo@kernel.org>, David Brown <david.brown@linaro.org>, Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>, Michael Ellerman <mpe@ellerman.id.au>, Mathias Krause <minipli@googlemail.com>, Thomas Gleixner <tglx@linutronix.de>, "x86@kernel.org" <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, linux-s390 <linux-s390@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 03/08/2016 01:41 AM, Kees Cook wrote:

>> --- a/arch/s390/kernel/vmlinux.lds.S
>> +++ b/arch/s390/kernel/vmlinux.lds.S
>> @@ -52,6 +52,12 @@ SECTIONS
>>
>>         RW_DATA_SECTION(0x100, PAGE_SIZE, THREAD_SIZE)
>>
>> +       . = ALIGN(PAGE_SIZE)


missing ";" ?


With that  and your fixes, this function claims to mark 0kB and 
lkdtm can still write. Reason is that _edata is 0xc11008 and start is
0x0c11000.

making _edata page aligned as well, does now try to mark one page, but then
we run into the next issue, that 

static void change_page_attr(unsigned long addr, int numpages,
                             pte_t (*set) (pte_t))
{
        pte_t *ptep;
        int i;

        for (i = 0; i < numpages; i++) {
                ptep = walk_page_table(addr);

triggers this
                if (WARN_ON_ONCE(!ptep))
                        break;

because the kernel decided to map this with a large page. So we need
to fix this function to then break the large page into a smaller chunk....

Christian
