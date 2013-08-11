Reply-To: kernel-hardening@lists.openwall.com
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201308031715.FCH73469.OVOHQStOFMLJFF@I-love.SAKURA.ne.jp>
	<20130807143151.GA4560@cachalot>
	<201308081950.HDC18500.OFSFMHOtFLJQVO@I-love.SAKURA.ne.jp>
In-Reply-To: <201308081950.HDC18500.OFSFMHOtFLJQVO@I-love.SAKURA.ne.jp>
Message-Id: <201308111150.EJG69287.LtOFFMOOFJSHQV@I-love.SAKURA.ne.jp>
Date: Sun, 11 Aug 2013 11:50:12 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: [kernel-hardening] Re: [RFC] KPortReserve : kernel version of portreserve utility
To: dhowells@redhat.com
Cc: segoon@openwall.com, twaugh@redhat.com, amwang@redhat.com, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, penguin-kernel@I-love.SAKURA.ne.jp
List-ID: <kernel-hardening.lists.openwall.com>

Hello.

Changes from version 1:

  (1) Changed interface file from /proc/reserved_local_port to
      /sys/kernel/security/kportreserve/entry .

  (2) Changed interface file to use "$port $program" rather than
      "add $port $program".

  (3) Changed to use the content of pathname passed to previous execve()
      request rather than the content of /proc/self/exe .

  (4) Added check whether the pathname passed to interface file is correct.

(1) is Casey's suggestion that all LSM controlling filesystems should use
securityfs.

(2) is Casey's comment that symmetric on read and write would be better.

(3) is Vasily's comment that the system may enter into condition where
d_absolute_path() returns -EINVAL. If the system enters into such condition,
this module cannot read /proc/self/exe at bind() time. Also, we might want to
distinguish interpreter-based programs and symlinked-multicall-binary-based
programs where the content of /proc/self/exe becomes the name of interpreter
program and the name of the entity of the multicall-binary program.



David, I have a question. To implement (3), I associated pathname passed to
previous execve() with "struct cred". But I'd like to check that this approach
works OK.

According to commit ee18d64c "KEYS: Add a keyctl to install a process's session
keyring on its parent [try #6]", it sounds to me that security_transfer_creds()
in key_change_session_keyring() replaces parent process's security domain with
child process's security domain.

If the child process called execve() after the parent process called fork(),
is the pathname associated with the parent process's "struct cred" replaced
with the pathname associated with the child process's "struct cred" by
security_transfer_creds() ?

Regards.
--------------------
>>From a5cdb8611328dc7877ff9c7b0e7419e77992572a Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Sun, 11 Aug 2013 11:41:22 +0900
Subject: [PATCHv2] KPortReserve : kernel version of portreserve utility

This module reserves local port like /proc/sys/net/ipv4/ip_local_reserved_ports
does, but this module is designed for stopping bind() requests with non-zero
local port numbers from unwanted programs.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 security/Kconfig               |    6 +
 security/Makefile              |    2 +
 security/kportreserve/Kconfig  |   35 +++
 security/kportreserve/Makefile |    1 +
 security/kportreserve/kpr.c    |  561 ++++++++++++++++++++++++++++++++++++++++
 5 files changed, 605 insertions(+), 0 deletions(-)
 create mode 100644 security/kportreserve/Kconfig
 create mode 100644 security/kportreserve/Makefile
 create mode 100644 security/kportreserve/kpr.c

diff --git a/security/Kconfig b/security/Kconfig
index e9c6ac7..f4058ff 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -122,6 +122,7 @@ source security/smack/Kconfig
 source security/tomoyo/Kconfig
 source security/apparmor/Kconfig
 source security/yama/Kconfig
+source security/kportreserve/Kconfig
 
 source security/integrity/Kconfig
 
@@ -132,6 +133,7 @@ choice
 	default DEFAULT_SECURITY_TOMOYO if SECURITY_TOMOYO
 	default DEFAULT_SECURITY_APPARMOR if SECURITY_APPARMOR
 	default DEFAULT_SECURITY_YAMA if SECURITY_YAMA
+	default DEFAULT_SECURITY_KPR if SECURITY_KPR
 	default DEFAULT_SECURITY_DAC
 
 	help
@@ -153,6 +155,9 @@ choice
 	config DEFAULT_SECURITY_YAMA
 		bool "Yama" if SECURITY_YAMA=y
 
+	config DEFAULT_SECURITY_KPR
+		bool "KPortReserve" if SECURITY_KPR=y
+
 	config DEFAULT_SECURITY_DAC
 		bool "Unix Discretionary Access Controls"
 
@@ -165,6 +170,7 @@ config DEFAULT_SECURITY
 	default "tomoyo" if DEFAULT_SECURITY_TOMOYO
 	default "apparmor" if DEFAULT_SECURITY_APPARMOR
 	default "yama" if DEFAULT_SECURITY_YAMA
+	default "kpr" if DEFAULT_SECURITY_KPR
 	default "" if DEFAULT_SECURITY_DAC
 
 endmenu
diff --git a/security/Makefile b/security/Makefile
index c26c81e..87f95cc 100644
--- a/security/Makefile
+++ b/security/Makefile
@@ -8,6 +8,7 @@ subdir-$(CONFIG_SECURITY_SMACK)		+= smack
 subdir-$(CONFIG_SECURITY_TOMOYO)        += tomoyo
 subdir-$(CONFIG_SECURITY_APPARMOR)	+= apparmor
 subdir-$(CONFIG_SECURITY_YAMA)		+= yama
+subdir-$(CONFIG_SECURITY_KPR)		+= kportreserve
 
 # always enable default capabilities
 obj-y					+= commoncap.o
@@ -23,6 +24,7 @@ obj-$(CONFIG_AUDIT)			+= lsm_audit.o
 obj-$(CONFIG_SECURITY_TOMOYO)		+= tomoyo/built-in.o
 obj-$(CONFIG_SECURITY_APPARMOR)		+= apparmor/built-in.o
 obj-$(CONFIG_SECURITY_YAMA)		+= yama/built-in.o
+obj-$(CONFIG_SECURITY_KPR)		+= kportreserve/built-in.o
 obj-$(CONFIG_CGROUP_DEVICE)		+= device_cgroup.o
 
 # Object integrity file lists
diff --git a/security/kportreserve/Kconfig b/security/kportreserve/Kconfig
new file mode 100644
index 0000000..73ad5bc
--- /dev/null
+++ b/security/kportreserve/Kconfig
@@ -0,0 +1,35 @@
+config SECURITY_KPR
+	bool "KPortReserve support"
+	depends on SECURITY
+	depends on PROC_FS
+	select SECURITY_NETWORK
+	default n
+	help
+	  This selects local port reserving module which is similar to
+	  /proc/sys/net/ipv4/ip_local_reserved_ports . But this module is
+	  designed for stopping bind() requests with non-zero local port
+	  numbers from unwanted programs using white list reservations.
+
+	  If you are unsure how to answer this question, answer N.
+
+	  Usage:
+
+          Use "add $port $program" format to add reservation.
+	  The $port is a single port number between 0 and 65535.
+	  The $program is the content of /proc/self/exe in TOMOYO's pathname
+	  representation rule (i.e. consists with only ASCII printable
+	  characters, and seen from the current thread's namespace's root (e.g.
+	  /var/chroot/bin/bash for /bin/bash running inside /var/chroot/
+	  chrooted environment)). The <kernel> means kernel threads).
+	  For example,
+	  
+	  # echo "add 10000 /bin/bash" > /proc/reserved_local_port
+	  # echo "add 20000 <kernel>" > /proc/reserved_local_port
+	  
+	  allows bind() on port 10000 to /bin/bash and allows bind() on port
+	  20000 to kernel threads.
+	  
+	  Use "del $port $program" format to remove reservation.
+
+	  Note that only port numbers which have at least one reservation are
+	  checked by this module.
diff --git a/security/kportreserve/Makefile b/security/kportreserve/Makefile
new file mode 100644
index 0000000..6342521
--- /dev/null
+++ b/security/kportreserve/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_SECURITY_KPR) := kpr.o
diff --git a/security/kportreserve/kpr.c b/security/kportreserve/kpr.c
new file mode 100644
index 0000000..7971f0b
--- /dev/null
+++ b/security/kportreserve/kpr.c
@@ -0,0 +1,561 @@
+/*
+ * kpr.c - kernel version of portreserve.
+ */
+#include <linux/security.h>
+#include <linux/vmalloc.h>
+#include <linux/net.h>
+#include <linux/inet.h>
+#include <linux/uaccess.h>
+#include <linux/binfmts.h>
+#include <net/sock.h>
+#include <net/ip.h>
+#include <net/ipv6.h>
+
+/* Max length of a line. */
+#define MAX_LINE_LEN 16384
+
+/* Port numbers with at least one whitelist element exists. */
+static unsigned long reserved_port_map[65536 / BITS_PER_LONG];
+
+/* Whitelist element. */
+struct reserved_port_entry {
+	struct list_head list;
+	const char *exe;
+	u16 port;
+};
+/* List of whitelist elements. */
+static LIST_HEAD(reserved_port_list);
+
+/* Per a "struct cred" info. */
+struct task_name_info {
+	atomic_t users;
+	char exe[0]; /* Content of current "struct linux_binprm"->filename . */
+};
+
+/**
+ * kpr_cred_alloc_blank - Target for security_cred_alloc_blank().
+ *
+ * @new: Pointer to "struct cred".
+ * @gfp: Memory allocation flags.
+ *
+ * Returns 0.
+ */
+static int kpr_cred_alloc_blank(struct cred *new, gfp_t gfp)
+{
+	new->security = NULL;
+	return 0;
+}
+
+/**
+ * kpr_cred_prepare - Target for security_prepare_creds().
+ *
+ * @new: Pointer to "struct cred".
+ * @old: Pointer to "struct cred".
+ * @gfp: Memory allocation flags.
+ *
+ * Returns 0.
+ */
+static int kpr_cred_prepare(struct cred *new, const struct cred *old,
+			       gfp_t gfp)
+{
+	struct task_name_info *info = old->security;
+	new->security = info;
+	if (info)
+		atomic_inc(&info->users);
+	return 0;
+}
+
+/**
+ * kpr_cred_transfer - Target for security_transfer_creds().
+ *
+ * @new: Pointer to "struct cred".
+ * @old: Pointer to "struct cred".
+ */
+static void kpr_cred_transfer(struct cred *new, const struct cred *old)
+{
+	kpr_cred_prepare(new, old, 0);
+}
+
+/**
+ * kpr_cred_free - Target for security_cred_free().
+ *
+ * @cred: Pointer to "struct cred".
+ */
+static void kpr_cred_free(struct cred *cred)
+{
+	struct task_name_info *info = cred->security;
+	if (info && atomic_dec_and_test(&info->users))
+		kfree(info);
+}
+
+/**
+ * kpr_make_info - Encode binary string to ascii string.
+ *
+ * @str: String in binary format.
+ *
+ * Returns pointer to "struct task_info_name" with @str in ascii format on
+ * success, NULL otherwise.
+ *
+ * This function uses kmalloc(), so caller must kfree() if this function
+ * didn't return NULL.
+ */
+static struct task_name_info *kpr_make_info(const char *str)
+{
+	int i;
+	int len = 0;
+	struct task_name_info *info;
+	const char *p = str;
+	char *cp;
+	const int str_len = strlen(str);
+
+	for (i = 0; i < str_len; i++) {
+		const unsigned char c = p[i];
+		if (c == '\\')
+			len += 2;
+		else if (c > ' ' && c < 127)
+			len++;
+		else
+			len += 4;
+	}
+	len++;
+	info = kmalloc(sizeof(*info) + len, GFP_KERNEL);
+	if (!info)
+		return NULL;
+	atomic_set(&info->users, 1);
+	cp = info->exe;
+	p = str;
+	for (i = 0; i < str_len; i++) {
+		const unsigned char c = p[i];
+		if (c == '\\') {
+			*cp++ = '\\';
+			*cp++ = '\\';
+		} else if (c > ' ' && c < 127) {
+			*cp++ = c;
+		} else {
+			*cp++ = '\\';
+			*cp++ = (c >> 6) + '0';
+			*cp++ = ((c >> 3) & 7) + '0';
+			*cp++ = (c & 7) + '0';
+		}
+	}
+	*cp = '\0';
+	return info;
+}
+
+/**
+ * kpr_correct_word - Validate a string.
+ *
+ * @string: The string to check.
+ *
+ * Check whether the given string follows the naming rules.
+ * Returns true if @string follows the naming rules, false otherwise.
+ */
+static bool kpr_correct_word(const char *string)
+{
+	if (!*string)
+		return false;
+	while (1) {
+		unsigned char c = *string++;
+		if (!c)
+			return true;
+		if (c == '\\') {
+			c = *string++;
+			switch (c) {
+			case '\\':  /* "\\" */
+				continue;
+			case '0':   /* "\ooo" */
+			case '1':
+			case '2':
+			case '3':
+				{
+					unsigned char d;
+					unsigned char e;
+					c -= '0';
+					d = *string++ - '0';
+					if (d > 7)
+						break;
+					e = *string++ - '0';
+					if (e > 7)
+						break;
+					c = (c << 6) + (d << 3) + (e);
+					if (c <= ' ' || c >= 127)
+						continue;
+				}
+			}
+			return false;
+		} else if (c <= ' ' || c >= 127) {
+			return false;
+		}
+	}
+	return true;
+}
+
+/**
+ * kpr_bprm_set_creds - Target for security_bprm_set_creds().
+ *
+ * @bprm: Pointer to "struct linux_binprm".
+ *
+ * Returns 0 on success, negative value otherwise.
+ */
+static int kpr_bprm_set_creds(struct linux_binprm *bprm)
+{
+	const int rc = cap_bprm_set_creds(bprm);
+
+	if (rc)
+		return rc;
+	if (!bprm->cred_prepared) {
+		struct task_name_info *info = kpr_make_info(bprm->filename);
+
+		if (!info)
+			return -ENOMEM;
+		kpr_cred_free(bprm->cred);
+		bprm->cred->security = info;
+	}
+	return 0;
+}
+
+
+/**
+ * kpr_socket_bind - Check permission for bind().
+ *
+ * @sock:     Pointer to "struct socket".
+ * @addr:     Pointer to "struct sockaddr".
+ * @addr_len: Size of @addr.
+ *
+ * Returns 0 on success, negative value otherwise.
+ */
+static int kpr_socket_bind(struct socket *sock, struct sockaddr *addr,
+			   int addr_len)
+{
+	u16 port;
+	switch (sock->sk->sk_family) {
+	case PF_INET:
+	case PF_INET6:
+		break;
+	default:
+		return 0;
+	}
+	switch (sock->type) {
+	case SOCK_STREAM:
+	case SOCK_DGRAM:
+		break;
+	default:
+		return 0;
+	}
+	switch (addr->sa_family) {
+	case AF_INET:
+		if (addr_len < sizeof(struct sockaddr_in))
+			return 0;
+		port = ((struct sockaddr_in *) addr)->sin_port;
+		break;
+	case AF_INET6:
+		if (addr_len < SIN6_LEN_RFC2133)
+			return 0;
+		port = ((struct sockaddr_in6 *) addr)->sin6_port;
+		break;
+	default:
+		return 0;
+	}
+	port = ntohs(port);
+	if (!test_bit(port, reserved_port_map))
+		return 0;
+	{
+		struct reserved_port_entry *ptr;
+		int ret = 0;
+		const char *exe = ((struct task_name_info *)
+				   current_security())->exe;
+		if (!exe)
+			exe = "<unknown>";
+		rcu_read_lock();
+		list_for_each_entry_rcu(ptr, &reserved_port_list, list) {
+			if (port != ptr->port)
+				continue;
+			if (strcmp(exe, ptr->exe)) {
+				ret = -EADDRINUSE;
+				continue;
+			}
+			ret = 0;
+			break;
+		}
+		rcu_read_unlock();
+		return ret;
+	}
+}
+
+/**
+ * kpr_read - read() for /sys/kernel/security/kportreserve/entry interface.
+ *
+ * @file:  Pointer to "struct file".
+ * @buf:   Pointer to buffer.
+ * @count: Size of @buf.
+ * @ppos:  Offset of @file.
+ *
+ * Returns bytes read on success, negative value otherwise.
+ */
+static ssize_t kpr_read(struct file *file, char __user *buf, size_t count,
+			loff_t *ppos)
+{
+	ssize_t copied = 0;
+	int error = 0;
+	int record = 0;
+	loff_t offset = 0;
+	char *data = vmalloc(MAX_LINE_LEN);
+	if (!data)
+		return -ENOMEM;
+	while (1) {
+		struct reserved_port_entry *ptr;
+		int i = 0;
+		data[0] = '\0';
+		rcu_read_lock();
+		list_for_each_entry_rcu(ptr, &reserved_port_list, list) {
+			if (i++ < record)
+				continue;
+			snprintf(data, MAX_LINE_LEN - 1, "%u %s\n", ptr->port,
+				 ptr->exe);
+			break;
+		}
+		rcu_read_unlock();
+		if (!data[0])
+			break;
+		for (i = 0; data[i]; i++) {
+			if (offset++ < *ppos)
+				continue;
+			if (put_user(data[i], buf)) {
+				error = -EFAULT;
+				break;
+			}
+			buf++;
+			copied++;
+			(*ppos)++;
+		}
+		record++;
+	}
+	vfree(data);
+	return copied ? copied : error;
+}
+
+/**
+ * kpr_normalize_line - Format string.
+ *
+ * @buffer: The line to normalize.
+ *
+ * Returns nothing.
+ *
+ * Leading and trailing whitespaces are removed.
+ * Multiple whitespaces are packed into single space.
+ */
+static void kpr_normalize_line(unsigned char *buffer)
+{
+	unsigned char *sp = buffer;
+	unsigned char *dp = buffer;
+	bool first = true;
+	while (*sp && (*sp <= ' ' || *sp >= 127))
+		sp++;
+	while (*sp) {
+		if (!first)
+			*dp++ = ' ';
+		first = false;
+		while (*sp > ' ' && *sp < 127)
+			*dp++ = *sp++;
+		while (*sp && (*sp <= ' ' || *sp >= 127))
+			sp++;
+	}
+	*dp = '\0';
+}
+
+/**
+ * kpr_find_entry - Find an existing entry.
+ *
+ * @port: Port number.
+ * @exe:  Pathname. NULL for any.
+ *
+ * Returns pointer to existing entry if found, NULL otherwise.
+ */
+static struct reserved_port_entry *kpr_find_entry(const u16 port,
+						  const char *exe)
+{
+	struct reserved_port_entry *ptr;
+	bool found = false;
+	rcu_read_lock();
+	list_for_each_entry_rcu(ptr, &reserved_port_list, list) {
+		if (port != ptr->port)
+			continue;
+		if (exe && strcmp(exe, ptr->exe))
+			continue;
+		found = true;
+		break;
+	}
+	rcu_read_unlock();
+	return found ? ptr : NULL;
+}
+
+/**
+ * kpr_update_entry - Update the list of whitelist elements.
+ *
+ * @data: Line of data to parse.
+ *
+ * Returns 0 on success, negative value otherwise.
+ *
+ * Caller holds a mutex to protect from concurrent updates.
+ */
+static int kpr_update_entry(const char *data)
+{
+	struct reserved_port_entry *ptr;
+	unsigned int port;
+	if (sscanf(data, "%u", &port) == 1 && port < 65536) {
+		const char *cp = strchr(data, ' ');
+		if (!cp++ || !kpr_correct_word(cp))
+			return -EINVAL;
+		if (kpr_find_entry(port, cp))
+			return 0;
+		ptr = kzalloc(sizeof(*ptr), GFP_KERNEL);
+		if (!ptr)
+			return -ENOMEM;
+		ptr->port = (u16) port;
+		ptr->exe = kstrdup(cp, GFP_KERNEL);
+		if (!ptr->exe) {
+			kfree(ptr);
+			return -ENOMEM;
+		}
+		list_add_tail_rcu(&ptr->list, &reserved_port_list);
+		set_bit(ptr->port, reserved_port_map);
+	} else if (sscanf(data, "del %u", &port) == 1 && port < 65536) {
+		const char *cp = strchr(data + 4, ' ');
+		if (!cp++ || !kpr_correct_word(cp))
+			return -EINVAL;
+		ptr = kpr_find_entry(port, cp);
+		if (!ptr)
+			return 0;
+		list_del_rcu(&ptr->list);
+		synchronize_rcu();
+		kfree(ptr->exe);
+		kfree(ptr);
+		if (!kpr_find_entry(port, NULL))
+			clear_bit(ptr->port, reserved_port_map);
+	} else {
+		return -EINVAL;
+	}
+	return 0;
+}
+
+/**
+ * kpr_write - write() for /sys/kernel/security/kportreserve/entry interface.
+ *
+ * @file:  Pointer to "struct file".
+ * @buf:   Domainname to transit to.
+ * @count: Size of @buf.
+ * @ppos:  Unused.
+ *
+ * Returns bytes parsed on success, negative value otherwise.
+ */
+static ssize_t kpr_write(struct file *file, const char __user *buf,
+			 size_t count, loff_t *ppos)
+{
+	char *data;
+	ssize_t copied = 0;
+	int error;
+	if (!count)
+		return 0;
+	if (count > MAX_LINE_LEN - 1)
+		count = MAX_LINE_LEN - 1;
+	data = vmalloc(count + 1);
+	if (!data)
+		return -ENOMEM;
+	if (copy_from_user(data, buf, count)) {
+		error = -EFAULT;
+		goto out;
+	}
+	data[count] = '\0';
+	while (1) {
+		static DEFINE_MUTEX(lock);
+		char *cp = strchr(data, '\n');
+		int len;
+		if (!cp) {
+			error = -EINVAL;
+			break;
+		}
+		*cp = '\0';
+		len = strlen(data) + 1;
+		kpr_normalize_line(data);
+		if (mutex_lock_interruptible(&lock)) {
+			error = -EINTR;
+			break;
+		}
+		error = kpr_update_entry(data);
+		mutex_unlock(&lock);
+		if (error < 0)
+			break;
+		copied += len;
+		memmove(data, data + len, strlen(data + len) + 1);
+	}
+out:
+	vfree(data);
+	return copied ? copied : error;
+}
+
+/* List of hooks. */
+static struct security_operations kpr_ops = {
+	.name             = "kpr",
+	.cred_prepare     = kpr_cred_prepare,
+	.cred_alloc_blank = kpr_cred_alloc_blank,
+	.cred_transfer    = kpr_cred_transfer,
+	.cred_free        = kpr_cred_free,
+	.bprm_set_creds   = kpr_bprm_set_creds,
+	.socket_bind      = kpr_socket_bind,
+};
+
+static bool kpr_registered;
+
+/**
+ * kpr_register - Register this module.
+ *
+ * Returns 0.
+ */
+static int __init kpr_register(void)
+{
+	struct cred *cred = (struct cred *) current_cred();
+	struct task_name_info *info;
+	const char kernel_name[] = "<kernel>";
+
+	if (!security_module_enable(&kpr_ops))
+		return 0;
+	info = kmalloc(sizeof(*info) + sizeof(kernel_name), GFP_KERNEL);
+	if (!info)
+		goto out;
+	atomic_set(&info->users, 1);
+	memcpy(info->exe, kernel_name, sizeof(kernel_name));
+	cred->security = info;
+	if (register_security(&kpr_ops))
+		goto out;
+	kpr_registered = true;
+	pr_info("KPortReserve initialized\n");
+	return 0;
+out:
+	panic("Failure registering kportreserve");
+}
+security_initcall(kpr_register);
+
+/* Operations for /sys/kernel/security/kportreserve/entry interface. */
+static const struct file_operations kpr_operations = {
+	.write = kpr_write,
+	.read  = kpr_read,
+};
+
+/**
+ * kpr_init - Initialize this module.
+ *
+ * Returns 0.
+ */
+static int __init kpr_init(void)
+{
+	if (kpr_registered) {
+		struct dentry *kpr_dir = securityfs_create_dir("kportreserve",
+							       NULL);
+		if (!kpr_dir ||
+		    !securityfs_create_file("entry", 0644, kpr_dir, NULL,
+					    &kpr_operations))
+			panic("Failure registering kportreserve");
+	}
+	return 0;
+}
+fs_initcall(kpr_init);
-- 
1.7.1
