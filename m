Reply-To: kernel-hardening@lists.openwall.com
From: Florian Weimer <fweimer@redhat.com>
Message-ID: <14b76703-8185-dadb-7605-10496331452c@redhat.com>
Date: Mon, 31 Oct 2016 11:48:45 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Stack guard canary massaging
To: kernel-hardening@lists.openwall.com, oss-security@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Sorry for cross-posting.

glibc does this to set up the stack canary:

static inline uintptr_t __attribute__ ((always_inline))
_dl_setup_stack_chk_guard (void *dl_random)
{
   union
   {
     uintptr_t num;
     unsigned char bytes[sizeof (uintptr_t)];
   } ret = { 0 };

   if (dl_random == NULL)
     {
       ret.bytes[sizeof (ret) - 1] = 255;
       ret.bytes[sizeof (ret) - 2] = '\n';
     }
   else
     {
       memcpy (ret.bytes, dl_random, sizeof (ret));
#if BYTE_ORDER == LITTLE_ENDIAN
       ret.num &= ~(uintptr_t) 0xff;
#elif BYTE_ORDER == BIG_ENDIAN
       ret.num &= ~((uintptr_t) 0xff << (8 * (sizeof (ret) - 1)));
#else
# error "BYTE_ORDER unknown"
#endif
     }
   return ret.num;
}

This is an elaborate way of setting ret.bytes[0] = '\0'.

The intent (determined from an old commit message) is to make it harder 
to obtain the canary value through a read buffer overflow of a 
NUL-terminated string: The read overflow will stop at the NUL byte and 
not include the random canary value, reducing the risk of inappropriate 
disclosure.

But this reduces entropy of the canary to 24 bits on 32-bit systems, so 
I wonder if this is the right trade-off here.

Thanks,
Florian
