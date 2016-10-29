Reply-To: kernel-hardening@lists.openwall.com
From: David Windsor <dwindsor@gmail.com>
Date: Sat, 29 Oct 2016 12:19:55 -0400
Message-Id: <1477757996-22468-5-git-send-email-dwindsor@gmail.com>
In-Reply-To: <1477757996-22468-1-git-send-email-dwindsor@gmail.com>
References: <1477757996-22468-1-git-send-email-dwindsor@gmail.com>
Subject: [kernel-hardening][RFC PATCH 4/5] fs: add overflow protection to struct pipe_inode_info.{readers|writers|files|waiting_writers}
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, elena.reshetova@intel.com, ishkamiel@gmail.com, takahiro.akashi@linaro.org, colin@cvidal.org, dwindsor@gmail.com
List-ID: <kernel-hardening.lists.openwall.com>

Change type of struct pipe_inode_info.{readers|writers|files|waiting_writers} to atomic_t.
This enables overflow protection: when CONFIG_HARDENED_ATOMIC is enabled, atomic_t variables
cannot be overflowed.

The copyright for the original PAX_REFCOUNT code:
  - all REFCOUNT code in general: PaX Team <pageexec@freemail.hu>
  - various false positive fixes: Mathias Krause <minipli@googlemail.com>
---
 fs/coredump.c             | 10 ++++----
 fs/pipe.c                 | 59 ++++++++++++++++++++++++-----------------------
 fs/splice.c               | 36 ++++++++++++++---------------
 include/linux/pipe_fs_i.h |  8 +++----
 4 files changed, 57 insertions(+), 56 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 8d323b4..4ae7b89 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -483,8 +483,8 @@ static void wait_for_dump_helpers(struct file *file)
 	struct pipe_inode_info *pipe = file->private_data;
 
 	pipe_lock(pipe);
-	pipe->readers++;
-	pipe->writers--;
+	atomic_inc(&pipe->readers);
+	atomic_dec(&pipe->writers);
 	wake_up_interruptible_sync(&pipe->wait);
 	kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
 	pipe_unlock(pipe);
@@ -493,11 +493,11 @@ static void wait_for_dump_helpers(struct file *file)
 	 * We actually want wait_event_freezable() but then we need
 	 * to clear TIF_SIGPENDING and improve dump_interrupted().
 	 */
-	wait_event_interruptible(pipe->wait, pipe->readers == 1);
+	wait_event_interruptible(pipe->wait, atomic_read(&pipe->readers) == 1);
 
 	pipe_lock(pipe);
-	pipe->readers--;
-	pipe->writers++;
+	atomic_dec(&pipe->readers);
+	atomic_inc(&pipe->writers);
 	pipe_unlock(pipe);
 }
 
diff --git a/fs/pipe.c b/fs/pipe.c
index 8e0d9f2..ceea372 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -62,7 +62,7 @@ unsigned long pipe_user_pages_soft = PIPE_DEF_BUFFERS * INR_OPEN_CUR;
 
 static void pipe_lock_nested(struct pipe_inode_info *pipe, int subclass)
 {
-	if (pipe->files)
+	if (atomic_read(&pipe->files))
 		mutex_lock_nested(&pipe->mutex, subclass);
 }
 
@@ -77,7 +77,7 @@ EXPORT_SYMBOL(pipe_lock);
 
 void pipe_unlock(struct pipe_inode_info *pipe)
 {
-	if (pipe->files)
+	if (atomic_read(&pipe->files))
 		mutex_unlock(&pipe->mutex);
 }
 EXPORT_SYMBOL(pipe_unlock);
@@ -310,9 +310,9 @@ pipe_read(struct kiocb *iocb, struct iov_iter *to)
 		}
 		if (bufs)	/* More to do? */
 			continue;
-		if (!pipe->writers)
+		if (!atomic_read(&pipe->writers))
 			break;
-		if (!pipe->waiting_writers) {
+		if (!atomic_read(&pipe->waiting_writers)) {
 			/* syscall merging: Usually we must not sleep
 			 * if O_NONBLOCK is set, or if we got some data.
 			 * But if a writer sleeps in kernel space, then
@@ -369,7 +369,7 @@ pipe_write(struct kiocb *iocb, struct iov_iter *from)
 
 	__pipe_lock(pipe);
 
-	if (!pipe->readers) {
+	if (!atomic_read(&pipe->readers)) {
 		send_sig(SIGPIPE, current, 0);
 		ret = -EPIPE;
 		goto out;
@@ -403,7 +403,7 @@ pipe_write(struct kiocb *iocb, struct iov_iter *from)
 	for (;;) {
 		int bufs;
 
-		if (!pipe->readers) {
+		if (!atomic_read(&pipe->readers)) {
 			send_sig(SIGPIPE, current, 0);
 			if (!ret)
 				ret = -EPIPE;
@@ -471,9 +471,9 @@ pipe_write(struct kiocb *iocb, struct iov_iter *from)
 			kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
 			do_wakeup = 0;
 		}
-		pipe->waiting_writers++;
+		atomic_inc(&pipe->waiting_writers);
 		pipe_wait(pipe);
-		pipe->waiting_writers--;
+		atomic_dec(&pipe->waiting_writers);
 	}
 out:
 	__pipe_unlock(pipe);
@@ -528,7 +528,7 @@ pipe_poll(struct file *filp, poll_table *wait)
 	mask = 0;
 	if (filp->f_mode & FMODE_READ) {
 		mask = (nrbufs > 0) ? POLLIN | POLLRDNORM : 0;
-		if (!pipe->writers && filp->f_version != pipe->w_counter)
+		if (!atomic_read(&pipe->writers) && filp->f_version != pipe->w_counter)
 			mask |= POLLHUP;
 	}
 
@@ -538,7 +538,7 @@ pipe_poll(struct file *filp, poll_table *wait)
 		 * Most Unices do not set POLLERR for FIFOs but on Linux they
 		 * behave exactly like pipes for poll().
 		 */
-		if (!pipe->readers)
+		if (!atomic_read(&pipe->readers))
 			mask |= POLLERR;
 	}
 
@@ -550,7 +550,7 @@ static void put_pipe_info(struct inode *inode, struct pipe_inode_info *pipe)
 	int kill = 0;
 
 	spin_lock(&inode->i_lock);
-	if (!--pipe->files) {
+	if (atomic_dec_and_test(&pipe->files)) {
 		inode->i_pipe = NULL;
 		kill = 1;
 	}
@@ -567,11 +567,11 @@ pipe_release(struct inode *inode, struct file *file)
 
 	__pipe_lock(pipe);
 	if (file->f_mode & FMODE_READ)
-		pipe->readers--;
+		atomic_dec(&pipe->readers);
 	if (file->f_mode & FMODE_WRITE)
-		pipe->writers--;
+		atomic_dec(&pipe->writers);
 
-	if (pipe->readers || pipe->writers) {
+	if (atomic_read(&pipe->readers) || atomic_read(&pipe->writers)) {
 		wake_up_interruptible_sync_poll(&pipe->wait, POLLIN | POLLOUT | POLLRDNORM | POLLWRNORM | POLLERR | POLLHUP);
 		kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
 		kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
@@ -708,8 +708,9 @@ static struct inode * get_pipe_inode(void)
 		goto fail_iput;
 
 	inode->i_pipe = pipe;
-	pipe->files = 2;
-	pipe->readers = pipe->writers = 1;
+	atomic_set(&pipe->files, 2);
+	atomic_set(&pipe->readers, 1);
+	atomic_set(&pipe->writers, 1);
 	inode->i_fop = &pipefifo_fops;
 
 	/*
@@ -891,17 +892,17 @@ static int fifo_open(struct inode *inode, struct file *filp)
 	spin_lock(&inode->i_lock);
 	if (inode->i_pipe) {
 		pipe = inode->i_pipe;
-		pipe->files++;
+		atomic_inc(&pipe->files);
 		spin_unlock(&inode->i_lock);
 	} else {
 		spin_unlock(&inode->i_lock);
 		pipe = alloc_pipe_info();
 		if (!pipe)
 			return -ENOMEM;
-		pipe->files = 1;
+		atomic_set(&pipe->files, 1);
 		spin_lock(&inode->i_lock);
 		if (unlikely(inode->i_pipe)) {
-			inode->i_pipe->files++;
+			atomic_inc(&inode->i_pipe->files);
 			spin_unlock(&inode->i_lock);
 			free_pipe_info(pipe);
 			pipe = inode->i_pipe;
@@ -926,10 +927,10 @@ static int fifo_open(struct inode *inode, struct file *filp)
 	 *  opened, even when there is no process writing the FIFO.
 	 */
 		pipe->r_counter++;
-		if (pipe->readers++ == 0)
+		if (atomic_inc_return(&pipe->readers) == 1)
 			wake_up_partner(pipe);
 
-		if (!is_pipe && !pipe->writers) {
+		if (!is_pipe && !atomic_read(&pipe->writers)) {
 			if ((filp->f_flags & O_NONBLOCK)) {
 				/* suppress POLLHUP until we have
 				 * seen a writer */
@@ -948,14 +949,14 @@ static int fifo_open(struct inode *inode, struct file *filp)
 	 *  errno=ENXIO when there is no process reading the FIFO.
 	 */
 		ret = -ENXIO;
-		if (!is_pipe && (filp->f_flags & O_NONBLOCK) && !pipe->readers)
+		if (!is_pipe && (filp->f_flags & O_NONBLOCK) && !atomic_read(&pipe->readers))
 			goto err;
 
 		pipe->w_counter++;
-		if (!pipe->writers++)
+		if (atomic_inc_return(&pipe->writers) == 1)
 			wake_up_partner(pipe);
 
-		if (!is_pipe && !pipe->readers) {
+		if (!is_pipe && !atomic_read(&pipe->readers)) {
 			if (wait_for_partner(pipe, &pipe->r_counter))
 				goto err_wr;
 		}
@@ -969,11 +970,11 @@ static int fifo_open(struct inode *inode, struct file *filp)
 	 *  the process can at least talk to itself.
 	 */
 
-		pipe->readers++;
-		pipe->writers++;
+		atomic_read(&pipe->readers);
+		atomic_inc(&pipe->writers);
 		pipe->r_counter++;
 		pipe->w_counter++;
-		if (pipe->readers == 1 || pipe->writers == 1)
+		if (atomic_read(&pipe->readers) == 1 || atomic_read(&pipe->writers) == 1)
 			wake_up_partner(pipe);
 		break;
 
@@ -987,13 +988,13 @@ static int fifo_open(struct inode *inode, struct file *filp)
 	return 0;
 
 err_rd:
-	if (!--pipe->readers)
+	if (atomic_dec_and_test(&pipe->readers))
 		wake_up_interruptible(&pipe->wait);
 	ret = -ERESTARTSYS;
 	goto err;
 
 err_wr:
-	if (!--pipe->writers)
+	if (atomic_dec_and_test(&pipe->writers))
 		wake_up_interruptible(&pipe->wait);
 	ret = -ERESTARTSYS;
 	goto err;
diff --git a/fs/splice.c b/fs/splice.c
index 153d4f3..8376baa 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -188,7 +188,7 @@ ssize_t splice_to_pipe(struct pipe_inode_info *pipe,
 	if (!spd_pages)
 		return 0;
 
-	if (unlikely(!pipe->readers)) {
+	if (unlikely(!atomic_read(&pipe->readers))) {
 		send_sig(SIGPIPE, current, 0);
 		ret = -EPIPE;
 		goto out;
@@ -227,7 +227,7 @@ ssize_t add_to_pipe(struct pipe_inode_info *pipe, struct pipe_buffer *buf)
 {
 	int ret;
 
-	if (unlikely(!pipe->readers)) {
+	if (unlikely(!atomic_read(&pipe->readers))) {
 		send_sig(SIGPIPE, current, 0);
 		ret = -EPIPE;
 	} else if (pipe->nrbufs == pipe->buffers) {
@@ -537,7 +537,7 @@ static int splice_from_pipe_feed(struct pipe_inode_info *pipe, struct splice_des
 			pipe_buf_release(pipe, buf);
 			pipe->curbuf = (pipe->curbuf + 1) & (pipe->buffers - 1);
 			pipe->nrbufs--;
-			if (pipe->files)
+			if (atomic_read(&pipe->files))
 				sd->need_wakeup = true;
 		}
 
@@ -568,10 +568,10 @@ static int splice_from_pipe_next(struct pipe_inode_info *pipe, struct splice_des
 		return -ERESTARTSYS;
 
 	while (!pipe->nrbufs) {
-		if (!pipe->writers)
+		if (!atomic_read(&pipe->writers))
 			return 0;
 
-		if (!pipe->waiting_writers && sd->num_spliced)
+		if (!atomic_read(&pipe->waiting_writers) && sd->num_spliced)
 			return 0;
 
 		if (sd->flags & SPLICE_F_NONBLOCK)
@@ -785,7 +785,7 @@ iter_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
 				pipe_buf_release(pipe, buf);
 				pipe->curbuf = (pipe->curbuf + 1) & (pipe->buffers - 1);
 				pipe->nrbufs--;
-				if (pipe->files)
+				if (atomic_read(&pipe->files))
 					sd.need_wakeup = true;
 			} else {
 				buf->offset += ret;
@@ -948,7 +948,7 @@ ssize_t splice_direct_to_actor(struct file *in, struct splice_desc *sd,
 		 * out of the pipe right after the splice_to_pipe(). So set
 		 * PIPE_READERS appropriately.
 		 */
-		pipe->readers = 1;
+		atomic_set(&pipe->readers, 1);
 
 		current->splice_pipe = pipe;
 	}
@@ -1095,9 +1095,9 @@ static int wait_for_space(struct pipe_inode_info *pipe, unsigned flags)
 			return -EAGAIN;
 		if (signal_pending(current))
 			return -ERESTARTSYS;
-		pipe->waiting_writers++;
+		atomic_inc(&pipe->waiting_writers);
 		pipe_wait(pipe);
-		pipe->waiting_writers--;
+		atomic_dec(&pipe->waiting_writers);
 	}
 	return 0;
 }
@@ -1445,9 +1445,9 @@ static int ipipe_prep(struct pipe_inode_info *pipe, unsigned int flags)
 			ret = -ERESTARTSYS;
 			break;
 		}
-		if (!pipe->writers)
+		if (!atomic_read(&pipe->writers))
 			break;
-		if (!pipe->waiting_writers) {
+		if (!atomic_read(&pipe->waiting_writers)) {
 			if (flags & SPLICE_F_NONBLOCK) {
 				ret = -EAGAIN;
 				break;
@@ -1479,7 +1479,7 @@ static int opipe_prep(struct pipe_inode_info *pipe, unsigned int flags)
 	pipe_lock(pipe);
 
 	while (pipe->nrbufs >= pipe->buffers) {
-		if (!pipe->readers) {
+		if (!atomic_read(&pipe->readers)) {
 			send_sig(SIGPIPE, current, 0);
 			ret = -EPIPE;
 			break;
@@ -1492,9 +1492,9 @@ static int opipe_prep(struct pipe_inode_info *pipe, unsigned int flags)
 			ret = -ERESTARTSYS;
 			break;
 		}
-		pipe->waiting_writers++;
+		atomic_inc(&pipe->waiting_writers);
 		pipe_wait(pipe);
-		pipe->waiting_writers--;
+		atomic_dec(&pipe->waiting_writers);
 	}
 
 	pipe_unlock(pipe);
@@ -1530,14 +1530,14 @@ static int splice_pipe_to_pipe(struct pipe_inode_info *ipipe,
 	pipe_double_lock(ipipe, opipe);
 
 	do {
-		if (!opipe->readers) {
+		if (!atomic_read(&opipe->readers)) {
 			send_sig(SIGPIPE, current, 0);
 			if (!ret)
 				ret = -EPIPE;
 			break;
 		}
 
-		if (!ipipe->nrbufs && !ipipe->writers)
+		if (!ipipe->nrbufs && !atomic_read(&ipipe->writers))
 			break;
 
 		/*
@@ -1634,7 +1634,7 @@ static int link_pipe(struct pipe_inode_info *ipipe,
 	pipe_double_lock(ipipe, opipe);
 
 	do {
-		if (!opipe->readers) {
+		if (!atomic_read(&opipe->readers)) {
 			send_sig(SIGPIPE, current, 0);
 			if (!ret)
 				ret = -EPIPE;
@@ -1679,7 +1679,7 @@ static int link_pipe(struct pipe_inode_info *ipipe,
 	 * return EAGAIN if we have the potential of some data in the
 	 * future, otherwise just return 0
 	 */
-	if (!ret && ipipe->waiting_writers && (flags & SPLICE_F_NONBLOCK))
+	if (!ret && atomic_read(&ipipe->waiting_writers) && (flags & SPLICE_F_NONBLOCK))
 		ret = -EAGAIN;
 
 	pipe_unlock(ipipe);
diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
index e7497c9..43ebf07 100644
--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -48,10 +48,10 @@ struct pipe_inode_info {
 	struct mutex mutex;
 	wait_queue_head_t wait;
 	unsigned int nrbufs, curbuf, buffers;
-	unsigned int readers;
-	unsigned int writers;
-	unsigned int files;
-	unsigned int waiting_writers;
+	atomic_t readers;
+	atomic_t writers;
+	atomic_t files;
+	atomic_t waiting_writers;
 	unsigned int r_counter;
 	unsigned int w_counter;
 	struct page *tmp_page;
-- 
2.7.4
